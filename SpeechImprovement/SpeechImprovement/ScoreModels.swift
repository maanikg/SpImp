//
//  ScoreModels.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-08.
//

import Foundation
import SwiftUI
import AVFAudio

var run = 1
//struct Score:Identifiable, Hashable{
extension TimeInterval{
    var hours: Int {return Int(self.rounded())/3600}
    var minutes: Int{return (Int(self.rounded())-hours*3600)/60}
    var seconds: Int{return Int(self.rounded())%60}
}

struct Score : Identifiable{
//    var run:Int = 1
    var date: Date //date, time of recording
    var scoreVal: Double = 0
    var badFeatures:[String] = []
    var goodFeatures:[String] = []
    var tips: [String] = [] //array of strings
    var storedFilename: String = ""
    var scoreName: String = ""
    var fullPath:String = ""
    var path:URL?
//    var url : URL?
    var duration: TimeInterval = TimeInterval()
//    var scoreColor: Color = Color(red:1.0-Double(scoreVal), green: scoreVal, blue:0.0)
    var scoreColor:Color = Color.black
    var id: Int = 0
    var resultsObserver = ResultsObserver()
//    try audioFileANalyzer.add(classifySoundRequest, withObserver: resultsObserver)
//    audioFileAnalyzer.analyze()
    
    init(date: Date = Date.now, scoreVal: Double = 50, badFeatures: [String] = [], goodFeatures: [String] = [], tips:[String] = [], fullPath:String = "", storedFilename: String = "temp", duration: TimeInterval = TimeInterval(0), scoreColor: Color = .black) {
        self.id = run
        self.date = date
        self.scoreVal = scoreVal
        self.badFeatures = badFeatures
        self.goodFeatures = goodFeatures
        self.tips = tips
        self.fullPath = fullPath
        self.path = URL(string: "file://\(self.fullPath)")
        self.storedFilename = storedFilename
        self.duration = duration
//        self.url = url
        self.scoreName = "Run \(run)"
        self.scoreColor = scoreVal > 75 ? .green : scoreVal > 50 ? .yellow : .red
        print("score: \(self.scoreVal), id: \(self.id), path: \(fullPath)")
//        print(fullPath)
        run = run+1
        if (!fullPath.isEmpty){
            analyze()
        }
    }
    
    static var example = Score(
        date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:92.6, badFeatures: ["Talked too fast", "Should use better flow"],
        goodFeatures: ["Great tone", "No stuttering"],
        tips: ["More effective spacing", "More convincing word choice"],
        storedFilename: "temp")
    
    func analyze() {
        do{
            let audioFileAnalyzer = createAnalyzer(audioFileURL: path!)
            try audioFileAnalyzer!.add(classifySoundRequest, withObserver: resultsObserver)
            audioFileAnalyzer?.analyze()
//            let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
//            let bufferSize = AVAudioFrameCount(audioFormat.sampleRate * 5.0)
//            let audioFormat = audioFileAnalyzer!.defaultFormat
//            let frameCount = UInt32(audioFormat.sampleRate * audioTimeInterval)
//            let timeRange = CMTimeRange(start: CMTime.zero, duration: CMTime(value: CMTimeValue(frameCount), timescale: audioFormat.sampleRate))
//            audioFileAnalyzer?.analyze(timeRange: timeRange)
        }catch{
            print("Error when analyzing: \(error)")
        }
    }
}

var archive: [Score] = [
    Score(date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:94.6, badFeatures: ["volume", "pacing"],
          goodFeatures: ["confidence", "expression"],
          tips: ["practice more"]),
    Score(date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:84.6, badFeatures: ["volume", "pacing"],
          goodFeatures: ["confidence", "expression"],
          tips: ["practice less"]),
    Score(date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:64.5, badFeatures: ["volume", "pacing"],
          goodFeatures: ["confidence", "expression"],
          tips: ["no practice"]),
    Score(date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:95.0, badFeatures: ["volume", "pacing"],
          goodFeatures: ["confidence", "expression"],
          tips: ["practice now"])
]
