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
    @Published var indexOfSpokenLetter: Int = -1

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
        func makeUtterance(_ string: String, preDelay: TimeInterval = 0, postDelay: TimeInterval = 0) -> AVSpeechUtterance {
            let u = AVSpeechUtterance(string: string)
            u.preUtteranceDelay = preDelay
            u.postUtteranceDelay = postDelay
            u.voice = voice
            return u
        }
        utterances.removeAll()
        utterances.append(makeUtterance(word, postDelay: 0.5))
        word
            .map(String.init)
            .forEach { utterances.append(makeUtterance($0, postDelay: 0.2)) }
        utterances.append(makeUtterance(word, preDelay: 0.5, postDelay: 0.5))
        self.startAudioSession()
        utterances.forEach { self.speechSynthesizer?.speak($0) }
    }
    
    func stop() {
        self.isSpeaking = false
        self.stopAudioSession()
    }
    
    private func indexOfUtterance(_ utterance: AVSpeechUtterance) -> Int {
        if let index = utterances.firstIndex(of: utterance) {
            if index < utterances.count - 1 {
                return index
            }
            else { return 0 }
        }
        else { return 0 }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.isSpeaking = true
        self.indexOfSpokenLetter = self.indexOfUtterance(utterance) - 1
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
