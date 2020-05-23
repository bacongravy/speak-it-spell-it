//
//  ContentView.swift
//  Speak It Spell It
//
//  Created by David Kramer on 5/23/20.
//  Copyright © 2020 David Kramer. All rights reserved.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @ObservedObject var wordRecognizer = WordRecognizer()
    @ObservedObject var wordSynthesizer = WordSynthesizer()

    var body: some View {
        VStack {
            Spacer()
            Text(self.wordRecognizer.word.isEmpty ?
                "Press the mic button and speak a word" : self.wordRecognizer.word)
                .font(.largeTitle)
                .fontWeight(.black).foregroundColor(self.wordRecognizer.word.isEmpty ? .gray : .black)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Button(action: {
                    self.wordRecognizer.toggleRecording()
                }, label: {
                    Image(systemName: !self.wordRecognizer.micEnabled ? "mic.slash" : (self.wordRecognizer.isRecording ? "mic.circle.fill" : "mic.circle"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 75)
                        .padding()
                        .disabled(!self.wordRecognizer.micEnabled)

                }).padding()
                Button(action: {
                    self.speak()
                }, label: {
                    Image(systemName: self.wordSynthesizer.isSpeaking ? "speaker.2" : "speaker")                        .resizable()
                    .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 75.0)
                    }).padding().disabled(self.wordRecognizer.word.isEmpty)
            }
        }
        .onAppear {
            self.wordRecognizer.getPermission()
        }
    }
    
    func speak() {
        self.wordSynthesizer.isSpeaking
            ? self.wordSynthesizer.stop()
            : self.wordSynthesizer.speak(self.wordRecognizer.word)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
