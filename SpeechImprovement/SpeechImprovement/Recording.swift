//
//  Recording.swift
//  Speechs
//
//  Created by Tyler Yan on 2023-05-07.
//
import SwiftUI
import Foundation

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
   
    var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                withAnimation {
                    recording = !recording;
                    if(recording) {
                        stopwatch.start()
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {  _ in
                            updateElapsedTime()
                        }
                    }
                    else {
                        stopwatch.stop()
                        // Create pop up window to go to score or to keep recording
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
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [Color.white, !recording ? Color.blue : Color.indigo], startPoint: .top, endPoint: .bottom)
        )
    }
        
}



struct Record_Previews: PreviewProvider {
    static var previews: some View {
        Record()
    }
}
