//
//  Score.swift
//  Speechs
//
//  Created by Tyler Yan on 2023-05-08.
//

//can we fix button size for the bottom buttons?

import Foundation
import SwiftUI
import AVFAudio

var audioRecorder:AVAudioRecorder?
var audioPlayer: AVAudioPlayer?

struct FinalScore: View {
//    var audioRecorder: AVAudioRecorder?
//    var audioPlayer: AVAudioPlayer?
    let score:Score
//    var userScore = 93.7
    var userColour: Color{
        if(score.scoreVal >= 0 && score.scoreVal <= 50) {
            return .red
        } else if(score.scoreVal <= 75) {
            return .yellow
        } else {
            return .green
        }
    }
    
    func playAudio(){
        if FileManager.default.fileExists(atPath:score.fullPath) {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: score.path!)
                audioPlayer?.stop()
                audioPlayer?.play()
                    } catch {
                        print(error)
                    }
        } else {
            print("Audio file does not exist")
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch let error {
            print("Error while stopping audio recording: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.black)
//                    Text(String(userScore))
                    Text(String(score.scoreVal))
                        .foregroundColor(userColour)
                        .bold()
                        .font(.title)
                }
                Button(action: {
                    playAudio()
                }) {
                    Image(systemName: "play.fill")
                        .padding()
                    Text("Listen to recording")
                        .font(.title3)
                        .bold()
                        .frame(alignment: .leading)
                }
                .tint(Color.black.opacity(0.25))
                .buttonStyle(.borderedProminent)
                
                Text((score.duration.hours != 0 ? "\(score.duration.hours) hrs: " : "") + (score.duration.minutes != 0 ? "\(score.duration.minutes) mins: ": "") + (score.duration.seconds != 0 ? "\(score.duration.seconds) secs": ""))
                    .font(.title2)
                Divider()
                    .background(.black)
                
                ScrollView{
                    VStack{
                        VStack{
                            Text("Bad:")
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(score.badFeatures, id: \.self) { feature in
                                Text("• \(feature)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom, 5)
                        VStack{
                            Text("Good:")
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(score.goodFeatures, id: \.self) { feature in
                                Text("• \(feature)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom, 5)
                        VStack{
                            Text("Tips:")
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(score.tips, id: \.self) { tip in
                                Text("• \(tip)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom, 5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity)
                HStack{
                    NavigationLink(destination: HomeScreen().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "chevron.backward")
                        Text("Home Page")
                    }
                    .tint(Color.black.opacity(0.25))
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    NavigationLink(destination: ArchivesScreen().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "list.bullet")
                        Text("All Scores")
                        
                    }
                    .tint(Color.black.opacity(0.25))
                    .buttonStyle(.borderedProminent)
                    .padding()
                }.foregroundColor(Color.black)
                
                
            }
            .padding()
            .navigationTitle("Your Score")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.black)
            .background(LinearGradient(colors: [Color.red, Color.indigo], startPoint: .top, endPoint: .bottom))
        }
    }
}


struct FinalScore_Previews: PreviewProvider {
    static var previews: some View {
        FinalScore(score: Score.example)
    }
}

