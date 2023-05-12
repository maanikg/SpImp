//
//  ContentView.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-03.
//

import SwiftUI
import AuthenticationServices
//var scoreArchive:ScoreList
//@State private var username: String = ""
let backgroundColor = LinearGradient(colors: [Color.white, Color.blue], startPoint: .top, endPoint: .bottom)
let title = Text("Speech Improvement")
    .font(.title)
    .fontWeight(.semibold)
    .foregroundColor(Color.black)
struct HomeScreen: View {
    @State private var signIn = false
    @State private var register = false
    var body: some View {
        NavigationStack(){
            
            ZStack{
                //            TextField ("Name",
                //                        text: .constant (""),
                //                        prompt: Text ("Please enter your name here"))
                //            SecureField("Password", text:.constant(""))
                VStack {
                    CircleImage()
                    VStack(alignment:.center){
                        //                    Text("Our First App!")
                        title
                        //                        .underline()
                        Divider()
                            .background(Color.black)
                        VStack(alignment:.center){
                            SignInButton(SignInWithAppleButton.Style.black)
                            //Navigation Link needed
//                            NavigationView{
                                NavigationLink(destination: IntermediateScreen().navigationBarBackButtonHidden(true)){
                                    Text("Bypass to Intermediate Screen")
                                }
                                .buttonStyle(.bordered)
                                .foregroundColor(Color.black)
                                
//                            }
                            //                        Spacer()
                            //                        NavigationLink(des)
                            //                        Button(action: {
                            //                            register=true
                            //                        }){
                            //                            Label("Register!", systemImage: "folder.badge.plus")
                            //                                .foregroundColor(Color.black)
                            //                                .bold()
                            //                        }
                            //                        .tint(Color.black)
                            //                        .buttonStyle(.bordered)
                        }
                        //                    HStack {
                        //                        Button(action: {
                        //                            signIn=true
                        //                        }){
                        //                            Label("Sign In!", systemImage: "lock.open")
                        //                                .foregroundColor(Color.black)
                        //                                .bold()
                        //                        }
                        //                        Spacer()
                        //                        Button(action: {
                        //                            register=true
                        //                        }){
                        //                            Label("Register!", systemImage: "folder.badge.plus")
                        //                                .foregroundColor(Color.black)
                        //                                .bold()
                        //
                        //                        }
                        //                        .tint(Color.black)
                        //                    }.buttonStyle(.bordered)
                        
                        
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
    }
    
    func SignInButton(_ type: SignInWithAppleButton.Style) -> some View{
        return SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
                print("Authorisation successful \(authResults)")
            case .failure(let error):
                print("Authorisation failed: \(error.localizedDescription)")
            }
        }
        //NEED TO CHANGE THIS MANUAL SETTING
        .frame(width: 200, height: 50, alignment: .center)
        .signInWithAppleButtonStyle(type)
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            HomeScreen()
        }
    }
}
