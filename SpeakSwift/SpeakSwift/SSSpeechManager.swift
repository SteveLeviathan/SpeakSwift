//
//  SSSpeechManager.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 09-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SSSpeechManager: NSObject, AVSpeechSynthesizerDelegate {
    
    /// The shared instance of the SSSpeechManager class
    static let sharedManager = SSSpeechManager()
    
    fileprivate override init() {}
    
    /* 
        The AVSpeechSynthesizer
    */
    var speechSynthesizer: AVSpeechSynthesizer {
        guard _speechSynthesizer == nil else { return _speechSynthesizer! }

        _speechSynthesizer = AVSpeechSynthesizer()

        return _speechSynthesizer!
    }
    private var _speechSynthesizer: AVSpeechSynthesizer? = nil
    
    /*
        Array of language codes, sorted alphabetically
    */
    var languageCodes: [String] {
        guard _languageCodes == nil else { return _languageCodes! }

        // Cast the Dictionary to NSDictionary
        // Then wen can use the keysSortedByValueUsingSelector method to sort the keys by value (language display name)

        _languageCodes = (languageCodesAndDisplayNames as NSDictionary).keysSortedByValue(using: #selector(NSNumber.compare)) as? [String]

        return _languageCodes!
    }
    private var _languageCodes: [String]? = nil
    
    /*
        A dictionary holding <language code/display names> key/value pairs with locale taken into account
    */
    var languageCodesAndDisplayNames: [String: String] {
        guard _languageCodesAndDisplayNames == nil else { return _languageCodesAndDisplayNames! }

        var languageCodes: [String] = []

        let speechVoices = AVSpeechSynthesisVoice.speechVoices()

        for voice in speechVoices {
            languageCodes.append(voice.language)
        }

        let currentLocale = Locale.autoupdatingCurrent

        var dictionary: [String: String] = [:]

        for languageCode in languageCodes {
            dictionary[languageCode] = (currentLocale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: languageCode)
        }

        _languageCodesAndDisplayNames = dictionary

        return _languageCodesAndDisplayNames!
    }
    private var _languageCodesAndDisplayNames: [String: String]? = nil
    
    
    func speakWithSpeechObject(_ speechObject: SSSpeechObject) {
        
        let speechUtterance = AVSpeechUtterance(string: speechObject.speechString)
        speechUtterance.rate = speechObject.rate
        speechUtterance.pitchMultiplier = speechObject.pitch
        
        let speechSynthesisVoice = AVSpeechSynthesisVoice(language: speechObject.language)!
        speechUtterance.voice = speechSynthesisVoice
        
        speechSynthesizer.speak(speechUtterance)
        
    }
    
}
