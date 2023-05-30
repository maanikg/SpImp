//
//  SpeechImprovementApp.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-03.
//

import SwiftUI
import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//      Auth.auth().useEmulator(withHost: "localhost", port: 9099)

    return true
  }
}

@main
struct SpeechImprovementApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject private var archive = ScoreData()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                AuthenticatedView{
//                    HomeScreen()
                    CircleImage()
//                    Image(systemName: "number.circle.fill")
//                      .resizable()
//                      .frame(width: 100 , height: 100)
//                      .foregroundColor(Color(.systemPink))
//                      .aspectRatio(contentMode: .fit)
//                      .clipShape(Circle())
//                      .clipped()
//                      .padding(4)
//                      .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    Text("Welcome to Speech Improvement!")
                      .font(.title)
                      .multilineTextAlignment(.center)
                    Text("You need to be logged in to use this app.")
                }content: {
                    RecordScreen()
                    Spacer()
                }
            }
//            HomeScreen()
//            ArchivesScreen()
//            IntermediateScreen()
        }
    }
}
