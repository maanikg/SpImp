//
//  Score.swift
//  Speechs
//
//  Created by Tyler Yan on 2023-05-08.
//

//can we fix button size for the bottom buttons?

import Foundation
import SwiftUI

struct FinalScore: View {
    var userScore = 93.7
    var userColour: Color{
        if(userScore >= 0 && userScore <= 50) {
            return .red
        } else if(userScore <= 75) {
            return .yellow
        } else {
            return .green
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Circle()
                        .frame(width: 100, height: 100)
                    Text(String(userScore))
                        .foregroundColor(userColour)
                        .font(.title)
                }
                ZStack{
                    ScrollView{
                        Text("Bad:")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("• Talked too fast")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("• Should use better flow")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 5)
                        
                        Text("Good:")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("• Great tone")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("• No stuttering")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 5)
                        
                        Text("Tips:")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("• More effective spacing")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("• More convincing word choice")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack{
                    NavigationLink(destination: HomeScreen().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "chevron.backward")
                        Text("Home Page")
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(8)
                    .padding()
                    
                    NavigationLink(destination: ArchivesScreen().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "list.bullet")
                        Text("All Scores")
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(8)
                    .padding()
                }.foregroundColor(Color.black)
                    
                    
            }
            .padding()
            .navigationTitle("Your Score")
            .navigationBarTitleDisplayMode(.large)
            .background(LinearGradient(colors: [Color.white, Color.indigo], startPoint: .top, endPoint: .bottom))
        }
    }
}


struct FinalScore_Previews: PreviewProvider {
    static var previews: some View {
        FinalScore()
    }
}

