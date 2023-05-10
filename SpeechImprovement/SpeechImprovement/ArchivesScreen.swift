//
//  Archives.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-07.
//

import SwiftUI

struct ArchivesScreen: View {
//    let scores:[Score]
//    @EnvironmentObject var scoreData: ScoreData
    
    var body: some View {
        NavigationView{
            VStack{
//                ForEach(scoreData.scores){$score in
//                    NavigationLink{
//                        PastScoreScreen(score: $score)
//                    }label:{
//                        ArchivedRunRow(score: $score)
//                    }
//                }
                //                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).bold()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [Color.red, Color.orange], startPoint: .top, endPoint: .bottom))
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Past Runs")
        }
        
        
        
        
    }
}

struct Archives_Previews: PreviewProvider {
    static var previews: some View {
//        ArchivesScreen(scores: archive)
                ArchivesScreen()
    }
}
