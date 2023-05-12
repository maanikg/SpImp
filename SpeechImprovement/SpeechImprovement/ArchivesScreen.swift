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
        NavigationView(){
            
            List{
//                Section(content: {
                    ForEach(archive) { score in
                        NavigationLink {
                            PastScoreScreen(score:score)
                        } label: {
                            ArchivedRunRow(score: score)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                //NEED TO CONFIGURE DELETE EVENT
                                //eventData.delete(event)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
//                    .listRowBackground(Color.blue)
//                }, header: {
//                    Text("temp")
//                        .font(.callout)
//                        .foregroundColor(.secondary)
//                        .fontWeight(.bold)
//                })
            }
            .scrollContentBackground(.hidden)
//            .foregroundColor(Color.purple)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [Color.orange, Color.yellow], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
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
