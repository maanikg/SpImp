//
//  ArchivedRunRow.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-09.
//

import SwiftUI

struct ArchivedRunRow: View {
    let score: Score
    var body: some View {
        HStack{
            Image(systemName: "waveform")
                .imageScale(.large)
                .bold()
            VStack(alignment: .leading, spacing: 5){
                Text(score.scoreName)
                    .fontWeight(.bold)
                    .font(.title2)
                Text(score.date.formatted(date:.abbreviated, time:.shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(score.tips[0] + "...")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(String(score.scoreVal))
                .font(.title3)
        }
            .padding()
    }
}

struct ArchivedRunRow_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedRunRow(score: Score.example)
    }
}
