//
//  AnnotationViewModel.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 29/10/25.
//

import SwiftUI
import AVFoundation
import SwiftData
import Combine

@MainActor
class AnnotationViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var annotationText: String = ""
    @Published var isSpeaking: Bool = false

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Speech
    func speak() {
        guard !annotationText.isEmpty, !synthesizer.isSpeaking else { return }
        let utterance = AVSpeechUtterance(string: annotationText)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate

        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    // MARK: - Save
    func saveAnnotation(context: ModelContext) {
        let newAnnotation = BookAnnotation(page: "", note: annotationText, date: Date())
        context.insert(newAnnotation)
        try? context.save()
    }

    // MARK: - Append scanned text
    func appendScannedText(_ text: String) {
        annotationText += text + "\n\n"
    }
}
