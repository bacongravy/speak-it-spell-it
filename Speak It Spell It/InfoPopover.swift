//
//  InfoPopover.swift
//  Speak It Spell It
//
//  Created by David Kramer on 5/25/20.
//  Copyright © 2020 David Kramer. All rights reserved.
//

import SwiftUI

struct InfoPopover: View {
    var body: some View {
        VStack {
            Text("Speak It Spell It")
                .font(.title).padding()
            Text("Use this app to explore how words are spelled. No distractions, no excuses.\n\nTo begin, press the microphone button, speak a word, and see it displayed on the screen.\n\nNext, to hear the word recited in the style of a spelling bee, press the speaker button, and hear the word.").padding()
        }
    }
}

struct InfoPopover_Previews: PreviewProvider {
    static var previews: some View {
        InfoPopover()
    }
}
