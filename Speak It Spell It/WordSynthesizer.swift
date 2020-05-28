//
//  WordSynthesizer.swift
//  Speak It Spell It
//
//  Created by David Kramer on 5/23/20.
//  Copyright © 2020 David Kramer. All rights reserved.
//

import Foundation
import AVKit

class WordSynthesizer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    var speechSynthesizer: AVSpeechSynthesizer?
    var utterances = Array<AVSpeechUtterance>()

    @Published var isSpeaking: Bool = false

    static func voices() -> [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice
            .speechVoices()
            .filter { $0.language.starts(with: "en") }
            .sorted { $0.name < $1.name }
    }
    
    static func defaultVoiceIndex() -> Int {
        return self.voices().firstIndex { $0.name == "Samantha" } ?? 0
    }
    
    private func startAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Could not start AVAudioSession.")
        }
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.speechSynthesizer?.delegate = self
    }
    
    private func stopAudioSession () {
        self.speechSynthesizer?.stopSpeaking(at: .immediate)
        self.speechSynthesizer = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Could not stop AVAudioSession.")
        }
    }
    
    func speak(_ word: String, voice: AVSpeechSynthesisVoice? = nil) {
        guard self.speechSynthesizer == nil else { return }
        func makeUtterance(_ string: String) -> AVSpeechUtterance {
            let u = AVSpeechUtterance(string: string)
            u.postUtteranceDelay = 0.5
            u.voice = voice
            return u
        }
        let letters = word
            .map(String.init)
            .joined(separator: ", ")
        utterances.removeAll()
        utterances.append(makeUtterance(word))
        utterances.append(makeUtterance(letters))
        utterances.append(makeUtterance(word))
        self.startAudioSession()
        utterances.forEach { self.speechSynthesizer?.speak($0) }
    }
    
    func stop() {
        self.isSpeaking = false
        self.stopAudioSession()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.isSpeaking = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (utterance == self.utterances.last) {
            self.stop()
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.stop()
    }

}
