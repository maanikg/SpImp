////
////  Recording.swift
////  Speechs
////
////  Created by Tyler Yan on 2023-05-07.
////
import SwiftUI
import Foundation
import UIKit
import AVKit

class StopWatch {
    var startTime: Date?
    var timer: Timer?
    var curTime: TimeInterval = 0.0
    
    func start() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            timer in self.curTime = -(self.startTime?.timeIntervalSinceNow ?? 0.0)
        }
    }
    
    func stop() {
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
    @State private var temp: Bool = true
   
    var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                withAnimation {
                    recording = !recording;
                    if(recording) {
                        do {
                            stopwatch.start()
                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            
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
                            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {  _ in
                                updateElapsedTime()
                            }
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                    else {
                        stopwatch.stop()
                        self.recorder.pause()
                        self.isPresented = true
                        // Create pop up window to go to score or to keep recording
                        let alert = UIAlertController(title: "Recording", message: "Would you like to continue recording?", preferredStyle: .alert)
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
                        }
                           
                
                        }
                }
            }
    }
    
    func updateElapsedTime() {
        timeLabel = String(format: "%.1f", stopwatch.curTime)
    }
    
    var body: some View {
        VStack{
            Text(!recording ? "Press to start recording" : "Press to finish recording")
                .font(.title)
                .bold()
            Image(!recording ? "notRecording" : "recording")
                .shadow(radius: 40)
                .gesture(tapGesture)
            Text(timeLabel)
                .font(.title)
                .bold()
            if shouldNavigate {
                NavigationLink(destination: FinalScore()) {
                    
                }
                .frame(width: 0, height: 0)
                .hidden()
                
            }
        }
        .onAppear {
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
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [Color.white, !recording ? Color.blue : Color.indigo], startPoint: .top, endPoint: .bottom)
        )
    }
    
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

struct PopUp: View {
    @Binding var shouldNavigate: Bool
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Text("Pop-Up Window")
                .font(.title)
                .padding()
            
            Button("Continue Recording") {
                self.dismiss()
            }
            .padding()
            
            Button("Done") {
                self.shouldNavigate = true
                self.dismiss()
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private func dismiss() {
        self.shouldNavigate = false
        presentationMode.wrappedValue.dismiss()
    }
}


struct Record_Previews: PreviewProvider {
    static var previews: some View {
        Record()
    }
}
