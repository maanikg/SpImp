//
//  Archives.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-07.
//

import SwiftUI

struct ArchivesScreen: View {
    //    let scores:[Score]
    
    var body: some View {
        NavigationView{
            VStack{
                
                ScrollView {
                    //            ForEach(scores){ score in scores
                    //
                    //            }
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [Color.red, Color.blue], startPoint: .top, endPoint: .bottom))
            .navigationBarTitleDisplayMode(.inline)
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
