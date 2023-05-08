//
//  RecordScreen.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-07.
//

import SwiftUI

struct RecordScreen: View {
    
    @State private var recording: Bool = false
    var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                withAnimation {
                    recording = !recording;
                }
            }
    }
    
    var body: some View {
        VStack{
            Text(!recording ? "Press to start recording" : "Press to finish recording")
                .font(.title)
                .bold()
            Image(!recording ? "notRecording" : "recording")
                .shadow(radius: 40)
                .gesture(tapGesture)
            NavigationLink(destination: HomeScreen()){
                Text("See Past Runs and Scores")
                    .foregroundColor(Color.black)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [Color.white, !recording ? Color.blue : Color.indigo], startPoint: .top, endPoint: .bottom)
        )
    }
        
}

struct RecordScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecordScreen()
    }
}
