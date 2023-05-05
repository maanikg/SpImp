//
//  ContentView.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-03.
//

import SwiftUI


//@State private var username: String = ""
let backgroundColor = LinearGradient(colors: [Color.white, Color.blue], startPoint: .top, endPoint: .bottom)
struct ContentView: View {
    @State private var signIn = false
    @State private var register = false
    var body: some View {
        ZStack{
//            TextField ("Name",
//                        text: .constant (""),
//                        prompt: Text ("Please enter your name here"))
//            SecureField("Password", text:.constant(""))
            VStack {
                CircleImage()
                VStack(alignment:.center){
//                    Text("Our First App!")
                    Text("Speech Improvement")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
//                        .underline()
                    Divider()
                        .background(Color.black)
                    HStack {
                    Button(action: {
                        signIn=true
                    }){
                        Label("Sign In!", systemImage: "lock.open")
                            .foregroundColor(Color.black)
                            .bold()
                    }
                    .tint(Color.black)
                    Spacer()
                        Button(action: {
                            register=true
                        }){
                            Label("Register!", systemImage: "folder.badge.plus")
                                .foregroundColor(Color.black)
                                .bold()
                                
                        }
                        .tint(Color.black)
                    }.buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .padding()
//        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.blue.gradient)
        .background(backgroundColor)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
