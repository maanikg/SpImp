////
////  Recording.swift
////  Speechs
////
////  Created by Tyler Yan on 2023-05-07.
///Modified By Ahmet Utku H. 2023-05-24
////

import SwiftUI
import Foundation
import UIKit
import AVKit
import Speech

import AVFoundation

//var mostRecentScore:Score = Score()

class AudioRecorder{
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    func startRecording(value: Bool) {
        if(value)
        {
            audioRecorder?.record()
        }
        else
        {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .allowBluetooth, .allowAirPlay])
                try audioSession.setActive(true)
                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let soundFilePath = documentPath[0].appendingPathComponent("audioRecording\(archive.count+1).m4a")
                let settings: [String: Any] = [ AVFormatIDKey: kAudioFormatAppleLossless,
                    AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                    AVEncoderBitRateKey: 32000,
                    AVNumberOfChannelsKey: 2,
                    AVSampleRateKey: 44100.0
                ]
                
                audioRecorder = try AVAudioRecorder(url: soundFilePath, settings: settings)
                audioRecorder?.isMeteringEnabled = true
                audioRecorder?.prepareToRecord()
                audioRecorder?.record()
            } catch let error {
                print("Error while recording audio: \(error.localizedDescription)")
            }
        }
    }
    
    func pauseRecording() {
        audioRecorder?.pause()
    }
    
    func restartRecording() {
        audioRecorder?.stop()
        audioRecorder?.deleteRecording()
        audioRecorder = nil
        //self.startRecording(value: false)
    }
    
    func stopRecording(ti: TimeInterval) {
        audioRecorder?.stop()
        
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFilePath = documentPath[0].appendingPathComponent("audioRecording\(archive.count+1).m4a")
        if fileManager.fileExists(atPath:soundFilePath.path) {
            
            let rec = audioRecorder
            archive.append(Score(date: Date.now, fullPath: soundFilePath.path, storedFilename: "audioRecording\(archive.count+1).m4a", duration: ti))
            // Convert recorded audio to speech
            convertAudioToSpeech(audioURL: rec!.url)
//            convertAudioToSpeech(audioURL: audioRecorder!.url)
        } else {
            print("Audio file does not exist")
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch let error {
            print("Error while stopping audio recording: \(error.localizedDescription)")
        }
    }
    
    private func convertAudioToSpeech(audioURL: URL) {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        let request = SFSpeechURLRecognitionRequest(url: audioURL)
        
        recognizer?.recognitionTask(with: request) { result, error in
            guard let result = result else {
                    print("Speech recognition failed: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if result.isFinal {
                    let transcription = result.bestTranscription.formattedString
                    print("Transcription: \(transcription)")
                    
                    // Do something with the transcription
                    // For example, display it in a text view
                    // textView.text = transcription
                }
            }
        }
}

class StopWatch {
    var startTime: Date?
    var timer: Timer?
    var curTime: TimeInterval = 0.0
    var temp = 0.0
    
    func start() {
        startTime = Date()
        if(curTime == 0.0) {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
                timer in self.curTime = -(self.startTime?.timeIntervalSinceNow ?? 0.0)
            }
        }
        else {
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
                timer in self.curTime = -(self.startTime?.timeIntervalSinceNow ?? 0.0) + self.temp
            }
        }
    }
    
    func stop() {
        temp = self.curTime
        timer?.invalidate()
        timer = nil
        startTime = nil
    }
    
    func reset() {
        stop()
        curTime = 0.0
    }
}

struct RecordScreen: View {
    
    @State private var recording: Bool = false
    @State private var timeLabel: String = "00:00"
    @State var stopwatch = StopWatch()
    @State var session: AVAudioSession!
    @State var recorder = AVAudioRecorder()
    @State var alert = false
    @State var audios: [URL] = []
    @State var isPresented = false
    @State var shouldNavigate = false
    @State var display: Bool = false
    @State var minute:Int = 0
    @State var timerDisplay: Timer?
    @State var records = AudioRecorder()
    @State var track = false
    @State var mostRecentScore:Score? = archive.last
    @State var hasMicrophoneAccess = AVCaptureDevice.authorizationStatus(for: .audio).rawValue == AVAuthorizationStatus.authorized.rawValue
    @State var hasMicrophoneAccessDenied = AVCaptureDevice.authorizationStatus(for: .audio).rawValue == AVAuthorizationStatus.denied.rawValue ||  AVCaptureDevice.authorizationStatus(for: .audio).rawValue == AVAuthorizationStatus.restricted.rawValue
    
    enum SystemAudioClassificationError: Error {
        
        /// The app encounters an interruption during audio recording.
        case audioStreamInterrupted
        
        /// The app doesn't have permission to access microphone input.
        case noMicrophoneAccess
    }
    
    
    
    private func ensureMicrophoneAccess() throws {
        //        var hasMicrophoneAccess = false
        //        print(AVCaptureDevice.authorizationStatus(for: .audio).rawValue)
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .notDetermined:
            let sem = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { success in
                //                hasMicrophoneAccess = success
                sem.signal()
            })
            _ = sem.wait(timeout: DispatchTime.distantFuture)
            //        case .denied, .restricted:
            //            break
            //        case .authorized:
            //            hasMicrophoneAccess = true
        case .denied, .restricted, .authorized:
            break
        @unknown default:
            fatalError("unknown authorization status for microphone access")
        }
        
        if !hasMicrophoneAccess {
            throw SystemAudioClassificationError.noMicrophoneAccess
        }
    }
    
    func startAudioSession() throws {
        stopAudioSession()
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
        } catch {
            stopAudioSession()
            throw error
        }
    }
    
    /// Deactivates the app's AVAudioSession.
    private func stopAudioSession() {
        autoreleasepool {
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setActive(false)
        }
    }
    
    
    var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
//                if (true){//hasMicrophoneAccess){
                    
                    withAnimation {
                        recording = !recording;
                        if(recording) {
//                            do {
                                //try ensureMicrophoneAccess()
                                //try startAudioSession()
//                            }//catch{
                               // stopAudioSession()
                            //}
                            do {
                                records.startRecording(value: track)
                                stopwatch.start()
                                display = false
                                track = true
                               
                                timerDisplay = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {  _ in
                                    updateElapsedTime()
                                }
                            }
                        }
                        else {
                            records.pauseRecording()
                            stopwatch.stop()
                            display.toggle()
                            timerDisplay?.invalidate()
                            //self.recorder.pause()
                            
                            
                            
                            
                            
//                        }
                    }
                }
            }
    }
    
    func updateElapsedTime() {
        if(Int(round(stopwatch.curTime)) % 60 == 0 && round(stopwatch.curTime) != 0) {
            minute += 1
        }
        timeLabel = String(format: "%02d:%02d", minute, Int(round(stopwatch.curTime))%60)
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
//                    Text(!recording ? "Press to start recording" : "Press to finish recording")
                    Text(recording ? "Press to stop recording" : stopwatch.curTime == 0 ? "Press to start recording" : "Press to resume recording")
                        .font(.title)
                        .bold()
                    Image(hasMicrophoneAccessDenied ? "notPermittedToRecord" : !recording ? "notRecording" : "recording")
                        .shadow(radius: 40)
                        .gesture(tapGesture)
                    
                    Text(timeLabel)
                        .font(.title)
                        .bold()
                    VStack{
                        
                        HStack{
                            Button(action: {
                                stopwatch.reset()
                                track = false
                                records.restartRecording()
                                timerDisplay?.invalidate()
                                timeLabel = String(format: "%02d:%02d", 0, 0)
                                recording = false
                                minute = 0
                                display = false
                            }) {
                                Text("Reset")
                                    .font(.title)
                                    .bold()
                                    .padding()
                            }.buttonStyle(.borderedProminent)
                            NavigationLink(destination: FinalScore(score:mostRecentScore!).navigationBarBackButtonHidden(true))
                            {
                                Text("Done")
                                    .font(.title)
                                    .bold()
                                    .padding()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(!display)
                            .simultaneousGesture(TapGesture().onEnded {
                                if (display){
                                    records.stopRecording(ti: stopwatch.curTime)
                                    mostRecentScore = archive.last!
                                }
                            })
                        }
                        NavigationLink(destination: ArchivesScreen().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "list.bullet")
                            Text("Past Runs")
                        }.disabled(archive.isEmpty)
                        .tint(Color.black.opacity(0.25))
                        .buttonStyle(.borderedProminent)
                        .opacity(archive.isEmpty ? 0 : 1)
                    }
                }
                .blur(radius: !hasMicrophoneAccessDenied ? 0.0 : 10.0)
                .disabled(hasMicrophoneAccessDenied)
                VStack {
                    Text("Please enable mic access in settings")
                        .padding()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .bold()
                }
                .opacity(!hasMicrophoneAccessDenied ? 0.0 : 1.0)
                .disabled(!hasMicrophoneAccessDenied)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [hasMicrophoneAccessDenied ? Color.black : Color.white, !recording ? Color.blue : Color.indigo], startPoint: .top, endPoint: .bottom))
//            let _ = print(hasMicrophoneAccessDenied.description)

        }
        
    }
    
    
    
    struct Record_Previews: PreviewProvider {
        static var previews: some View {
            RecordScreen()
        }
    }
}
