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
        NavigationStack(){
            VStack{
                HStack{
//                    NavigationLink(destination: HomeScreen().navigationBarBackButtonHidden(true)) {
//                        Image(systemName: "house")
//                        Text("Home Page")
//                    }
//                    .tint(Color.black.opacity(0.25))
//                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink(destination: RecordScreen().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "mic.fill")
                        Text("Record")
                    }
                    .tint(Color.black.opacity(0.25))
                    .buttonStyle(.borderedProminent)
                    
                }.foregroundColor(Color.black)
                    .padding()
                
                List{
                    //                Section(content: {
                    ForEach(archive) { score in
                        NavigationLink {
                            FinalScore(score:score)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            ArchivedRunRow(score: score)
                        }
                        .swipeActions (edge: .leading) {
                            Button(role: .destructive) {
                                //NEED TO CONFIGURE DELETE EVENT
                                //eventData.delete(event)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
//                            Button(role: .)
                        }
//                        .swipeActions(edge: .leading){
//
//                        }
                    }
//                    .background(Color.red)
                    .listRowBackground(LinearGradient(colors: [Color.blue, Color.purple], startPoint: .leading, endPoint: .trailing).ignoresSafeArea())
                    .listRowSeparator(.visible)
                    
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
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("Past Runs")
            }.background(LinearGradient(colors: [Color.orange, Color.yellow], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        }
    }
}

struct Archives_Previews: PreviewProvider {
    static var previews: some View {
//        ArchivesScreen(scores: archive)
                ArchivesScreen()
    }
}
