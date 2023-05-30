//
//  ScoreData.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-09.
//

import SwiftUI

@MainActor
class ScoreData: ObservableObject {
    @Published var scores: [Score] = [Score.example]
    
//    private static func fileURL() throws -> URL {
//        try FileManager.default.url(for: .documentDirectory,
//                                    in: .userDomainMask,
//                                    appropriateFor: nil,
//                                    create: false)
//        .appendingPathComponent("scores.data")
//    }
//    func load() async throws {
//        let task = Task<[Score], Error> {
//            let fileURL = try Self.fileURL()
//            guard let data = try? Data(contentsOf: fileURL) else {
//                return []
//            }
//            let allScores = try JSONDecoder().decode([Score].self, from: data)
//            return allScores
//        }
//        let scores = try await task.value
//    }
//
//    func save(scores: [Score]) async throws {
//            let task = Task {
//                let data = try JSONEncoder().encode(scores)
//                let outfile = try Self.fileURL()
//                try data.write(to: outfile)
//            }
//            _ = try await task.value
//        }
}
