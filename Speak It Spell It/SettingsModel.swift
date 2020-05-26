//
//  SettingsModel.swift
//  Speak It Spell It
//
//  Created by David Kramer on 5/26/20.
//  Copyright © 2020 David Kramer. All rights reserved.
//

import Foundation
import AVKit

class SettingsModel: ObservableObject {
    static private var voices = WordSynthesizer.voices()
    @Published var gearPopoverIsPresented: Bool = false
    @Published var selectedVoiceIndex: Int = WordSynthesizer.defaultVoiceIndex() {
        didSet {
            self.gearPopoverIsPresented = false
            self.selectedVoice = SettingsModel.voices[self.selectedVoiceIndex]
        }
    }
    @Published var selectedVoice = SettingsModel.voices[WordSynthesizer.defaultVoiceIndex()]
}
