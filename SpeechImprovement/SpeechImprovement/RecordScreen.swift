////
////  Recording.swift
////  Speechs
////
////  Created by Tyler Yan on 2023-05-07.
////

import SwiftUI
import Foundation
//import UIKit
import AVKit
import Speech

import AVFoundation

class AudioRecorder{
    
    private var audioRecorder: AVAudioRecorder?
    
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
                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let soundFilePath = documentPath.appendingPathComponent("audioRecording.m4a")
                let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
                audioRecorder = try AVAudioRecorder(url: soundFilePath, settings: settings)
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
        self.startRecording(value: false)
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch let error {
            print("Error while stopping audio recording: \(error.localizedDescription)")
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

struct Record: View {
    
    @State private var recording: Bool = false
    @State private var timeLabel:
    String = "00:00"
    @State var stopwatch = StopWatch()
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var alert = false
    @State var audios: [URL] = []
    @State var isPresented = false
    @State var shouldNavigate = false
    @State var display: Bool = false
    @State var minute = 0
    @State var timerDisplay: Timer?
    @State var records = AudioRecorder()
    @State var track = false
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
                if (hasMicrophoneAccess){
                    
                    withAnimation {
                        recording = !recording;
                        if(recording) {
                            do {
                                try ensureMicrophoneAccess()
                                try startAudioSession()
                            }catch{
                                stopAudioSession()
                            }
                            do {
                                records.startRecording(value: track)
                                stopwatch.start()
                                display = false
                                track = true
                                /*  let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                 
                                 // same file name...
                                 // so were updating based on audio count...
                                 let filName = url.appendingPathComponent("myRcd\(self.audios.count + 1).m4a")
                                 
                                 let settings = [
                                 
                                 AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                                 AVSampleRateKey : 12000,
                                 AVNumberOfChannelsKey : 1,
                                 AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                                 
                                 ]
                                 
                                 self.recorder = try AVAudioRecorder(url: filName, settings: settings)
                                 self.recorder.record()
                                 */
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
                            
                            
                            // Create pop up window to go to score or to keep recording
                            /*let alert = UIAlertController(title: "Recording", message: "Would you like to continue recording?", preferredStyle: .alert)
                             let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
                             // Do something when OK is tapped
                             // This can be left blank if you just want the window to dismiss
                             
                             self.recorder.stop()
                             self.getAudios()
                             NavigationLink(destination: FinalScore(), isActive: $temp) {
                             EmptyView()
                             }
                             }
                             
                             let continueAction = UIAlertAction(title: "Continue Recording", style: .default) { (_) in
                             
                             self.recorder.record()
                             stopwatch.start()
                             recording = true
                             }
                             
                             alert.addAction(doneAction)
                             alert.addAction(continueAction)
                             // Present the alert controller
                             if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                             let sceneDelegate = windowScene.delegate as? SceneDelegate,
                             let viewController = sceneDelegate.window?.rootViewController {
                             viewController.present(alert, animated: true, completion: nil)
                             }*/
                            
                            
                        }
                    }
                }
            }
    }
    
    func updateElapsedTime() {
        if(Int(stopwatch.curTime) % 60 == 0 && Int(stopwatch.curTime) != 0) {
            minute += 1
        }
        timeLabel = String(format: "%02d:%02d", Int(minute), Int(stopwatch.curTime)%60)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Text(hasMicrophoneAccessDenied ? "Please enable mic access" : !recording ? "Press to start recording" : "Press to finish recording")
                    .font(.title)
                    .bold()
                Image(hasMicrophoneAccessDenied ? "notPermittedToRecord" : !recording ? "notRecording" : "recording")
                    .shadow(radius: 40)
                    .gesture(tapGesture)
                Text(timeLabel)
                    .font(.title)
                    .bold()
                HStack{
                    Button(action: {
                        stopwatch.reset()
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
                    }
                    NavigationLink(destination: FinalScore()) {
                        Text("Done")
                            .font(.title)
                            .bold()
                            .padding()
                    }
                    .disabled(!display)
                    .simultaneousGesture(TapGesture().onEnded {
                        records.stopRecording()
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            LinearGradient(colors: [Color.white, !recording ? Color.blue : Color.indigo], startPoint: .top, endPoint: .bottom)
        }
        
    }
    
    /*.onAppear {
     do {
     self.session = AVAudioSession.sharedInstance()
     try self.session.setCategory(.playAndRecord)
     
     self.session.requestRecordPermission { (status) in
     if !status {
     self.alert.toggle()
     }
     else {
     self.getAudios()
     }
     }
     }
     catch {
     print(error.localizedDescription)
     }
     }*/
    
    
}

/*
 func getAudios() {
 do {
 let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 
 // fetch all data from document directory...
 
 let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
 
 // updated means remove all old data..
 
 self.audios.removeAll()
 
 for i in result{
 
 self.audios.append(i)
 }
 }
 catch{
 print(error.localizedDescription)
 }
 }
 }
 
 */

struct Record_Previews: PreviewProvider {
    static var previews: some View {
        Record()
    }
}
