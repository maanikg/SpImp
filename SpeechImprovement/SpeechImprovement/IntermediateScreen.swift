//
//  RecordScreen.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-07.
//

import SwiftUI

struct IntermediateScreen: View {
    
    //    @State private var recording: Bool = false 
    //    var tapGesture: some Gesture {
    //        TapGesture()
    //            .onEnded {
    //                withAnimation {
    //                    recording = !recording;
    //                }
    //            }
    //    }
    struct AlignedIconTextStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack(alignment: .center) {
                configuration.title
                configuration.icon
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationView{
                VStack{
                    NavigationLink(destination: Record()){
                        Label{
                            Text("Press to go to recording screen")
                                .multilineTextAlignment(.trailing)
                                .font(.title)
                                .foregroundColor(Color.black)
                                .bold()
                                .padding()
                        } icon:{
                            Image(systemName:"arrow.forward")
                                .foregroundColor(Color.black)
                                .bold()
                        }.labelStyle(AlignedIconTextStyle())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                            .background(Color.red.opacity(0.25))
                            .cornerRadius(8)
                    }
                    NavigationLink(destination: ArchivesScreen()){
                        Label{
                            Text("See Past Runs and Scores")
                                .foregroundColor(Color.black)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        } icon:{
                            Image(systemName:"return")
                                .foregroundColor(Color.black)
                        }
                        .background(Color.indigo.opacity(0.25))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(colors: [Color.white,Color.blue], startPoint: .top, endPoint: .bottom))
            }
        }
    }
}

struct RecordScreen_Previews: PreviewProvider {
    static var previews: some View {
        IntermediateScreen()
    }
}
