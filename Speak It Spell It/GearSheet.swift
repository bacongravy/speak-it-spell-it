//
//  GearSheet.swift
//  Speak It Spell It
//
//  Created by David Kramer on 5/25/20.
//  Copyright © 2020 David Kramer. All rights reserved.
//

import SwiftUI
import AVKit

struct SelectionCell: View {

    let label: String
    let index: Int
    @Binding var selectedIndex: Int

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            if index == selectedIndex {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .onTapGesture {
            self.selectedIndex = self.index
        }
    }
}

struct GearSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedVoiceIndex: Int
    private let voices = WordSynthesizer.voices()

    var body: some View {
        VStack {
            Text("Voices")
                .font(.title)
                .padding()
            List {
                ForEach(0 ..< voices.count, id: \.self) {
                    SelectionCell(label: self.voices[$0].name, index: $0, selectedIndex: self.$selectedVoiceIndex)
                }
            }
        }
    }
}

struct GearSheet_Previews: PreviewProvider {
    static var previews: some View {
        GearSheet(isPresented: .constant(true), selectedVoiceIndex: .constant(0))
    }
}

