//
//  ScoreModels.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-08.
//

import Foundation
import SwiftUI

//struct Score:Identifiable, Hashable{
struct Score : Identifiable{
    var date = Date() //date, time of recording
    var scoreVal: Double = 0
    var badFeatures, goodFeatures, tips: [String] //array of strings
    var storedFilename: String = ""
    var scoreName: String = ""
//    var scoreColor: Color = Color(red:1.0-Double(scoreVal), green: scoreVal, blue:0.0)
    var scoreColor:Color = Color.black
    var id: String{scoreName+String(scoreVal)}
    
    static var example = Score(
        date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:94.6, badFeatures: ["volume", "pacing"],
        goodFeatures: ["confidence", "expression"],
        tips: ["practice more"],
        scoreName:"Run 1")
}

var archive: [Score] = [
    Score(date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:94.6, badFeatures: ["volume", "pacing"],
          goodFeatures: ["confidence", "expression"],
          tips: ["practice more"],
          scoreName:"Run 1"),
    Score(date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:84.6, badFeatures: ["volume", "pacing"],
          goodFeatures: ["confidence", "expression"],
          tips: ["practice less"],
          scoreName:"Run 2"),
    Score(date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:64.5, badFeatures: ["volume", "pacing"],
          goodFeatures: ["confidence", "expression"],
          tips: ["no practice"],
          scoreName:"Run 3"),
    Score(date:Date(timeIntervalSinceNow: 60*60*24*365*1.5), scoreVal:95.0, badFeatures: ["volume", "pacing"],
          goodFeatures: ["confidence", "expression"],
          tips: ["practice now"],
          scoreName:"Run 4")
]
