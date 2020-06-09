//
//  WordRecognizer.swift
//  Speak It Spell It
//
//  Created by David Kramer on 5/23/20.
//  Copyright © 2020 David Kramer. All rights reserved.
//

import Foundation
import Speech

class WordRecognizer: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer()!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var word: String = ""
    @Published var isRecording: Bool = false
    @Published var micEnabled: Bool = false
    
    
    init (){
    }
    
    // originally from https://developer.apple.com/documentation/speech/recognizing_speech_in_live_audio
    func startRecording() throws {
        recognitionTask?.cancel()
        self.recognitionTask = nil
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = false
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                self.word = result.bestTranscription.formattedString.lowercased()
                isFinal = result.isFinal
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.isRecording = false
            }
            else {
                recognitionRequest.endAudio()
                self.audioEngine.stop()
                self.isRecording = false
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopRecording(){
        recognitionRequest?.endAudio()
        audioEngine.stop()
        isRecording = false
    }
    
    func toggleRecording(){
        if audioEngine.isRunning {
            stopRecording()
        } else {
            do {
                try startRecording()
                isRecording = true
            } catch {
                isRecording = false
            }
        }
    }
    
    func getPermission(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.micEnabled = true
                case .denied, .restricted, .notDetermined:
                    self.micEnabled = false
                default:
                    self.micEnabled = false
                }
            }
        }
    }
}
