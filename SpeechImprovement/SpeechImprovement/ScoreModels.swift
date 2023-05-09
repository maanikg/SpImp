//
//  ScoreModels.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-08.
//

import Foundation

struct ScoreList{
    
    var scores: [Score] = []
}

struct Score{
    var datetime: Date //date, time of recording
    var scoreVal: Int
    var badFeatures, goodFeatures, tips: [String] //array of strings
}
