//
//  ScoreData.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-09.
//

import SwiftUI

class ScoreData: ObservableObject {
    @Published var scores: [Score] = [Score.example]
}
