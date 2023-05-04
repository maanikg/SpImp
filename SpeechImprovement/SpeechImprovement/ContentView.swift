//
//  ContentView.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-03.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CircleImage()
//            Image(systemName: "swift")
//                .imageScale(.large)
//                .foregroundColor(Color.orange)
            VStack(alignment:.leading){
                Text("Our First App!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.indigo)
                Divider()
                HStack {
                    Text("Created on May 3, 2023")
                        .font(.headline)
                    Spacer()
                    Text("Maanik, Tyler")
                        .font(.subheadline)
                        .foregroundColor(Color.green)
                    
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
