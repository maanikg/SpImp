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
//TODO: STRUCT OR CLASS?
class Score : Identifiable{
//    var run:Int = 1
    var date: Date //date, time of recording
    var scoreVal: Double = 0
    var badFeatures:[String] = []
    var goodFeatures:[String] = []
    var tips: [String] = [] //array of strings
    var storedFilename: String = ""
    var scoreName: String = ""
    var fullPath:String = ""
    var toneDict:[String:Double] = [:]
    var toneScore:Double  = 0
    var path:URL?
    var moreInfo:String = ""
//    var url : URL?
    var duration: TimeInterval = TimeInterval()
//    var scoreColor: Color = Color(red:1.0-Double(scoreVal), green: scoreVal, blue:0.0)
    @State var scoreColor:Color = Color.black
    var id: Int = 0
//    var soundModelResults:[ResultsObserver]
    var resultsObserver:ResultsObserver
//    var resultsObserver:ResultsObserver(self)
//    try audioFileANalyzer.add(classifySoundRequest, withObserver: resultsObserver)
//    audioFileAnalyzer.analyze()
    
    init(date: Date = Date.now, scoreVal: Double = 50, badFeatures: [String] = [], goodFeatures: [String] = [], tips:[String] = [], fullPath:String = "", storedFilename: String = "temp", duration: TimeInterval = TimeInterval(0), scoreColor: Color = .black) {
        self.id = run
        self.date = date
        
        self.badFeatures = badFeatures
        self.goodFeatures = goodFeatures
        self.tips = tips
        self.fullPath = fullPath
        self.path = URL(string: "file://\(self.fullPath)")
        self.storedFilename = storedFilename
        self.duration = duration
        self.resultsObserver = ResultsObserver()
//        self.url = url
        self.scoreVal = scoreVal
        self.scoreColor = scoreVal > 75 ? .green : scoreVal > 50 ? .yellow : .red
        self.scoreName = "Run \(run)"
        
//        self.resultsObserver = ResultsObserver(score:self)
//        print("score: \(self.scoreVal), id: \(self.id), path: \(fullPath)")
//        print(fullPath)
        run = run+1
        if (!fullPath.isEmpty){
            analyze()
            self.moreInfo = fillMoreInfo()
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
            try audioFileAnalyzer!.add(classifyToneSoundReq, withObserver: resultsObserver)
//            try audioFileAnalyzer!.add(classifyToneSoundReq1, withObserver: resultsObserver)
            // try audioFileAnalyzer!.add(classifyVolumeSoundReq, withObserver: resultsObserver)
            // try audioFileAnalyzer!.add(classifySpeedSoundReq, withObserver: resultsObserver)
            // try audioFileAnalyzer!.add(classifyClaritySoundReq, withObserver: resultsObserver)
            audioFileAnalyzer?.analyze()
            self.toneDict = resultsObserver.resultDict["Tone"]!
            for i in self.toneDict.sorted(by: {$0.value > $1.value}){ //sorts from highest to lowest
                let localPercent:Double = i.value/resultsObserver.totalAnalysisTime*100
                if (toneOrder[i.key] != 0){
                    toneScore += Double(toneOrder[i.key]!)/Double(toneOrder.count-1) * localPercent
                }
                if (i.value/resultsObserver.totalAnalysisTime*100 != 0){
                    self.badFeatures.append("\(i.key): " + String(format: "%.2f%%", localPercent))
                }
            }
            scoreVal = Double(round(10*toneScore)/10)
        }catch{
            print("Error when analyzing: \(error)")
        }
    }
    
    func fillMoreInfo() ->String{
        var moreInfoText:String = ""
        if let firstTip = self.tips.first{
            moreInfoText = firstTip
        }else if let firstGood = self.goodFeatures.first{
            moreInfoText = firstGood
        }else if let firstBad = self.badFeatures.first{
            moreInfoText = firstBad
        }else{
            moreInfoText = "..."
        }
        return moreInfoText
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
