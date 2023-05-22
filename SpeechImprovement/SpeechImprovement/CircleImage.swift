//
//  waveform.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-03.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Image("waveform")
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.black, lineWidth: 5)
            }
            .shadow(radius: 20)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
