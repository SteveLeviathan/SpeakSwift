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
import Crashlytics

class SSSpeechManager : NSObject, AVSpeechSynthesizerDelegate {
    
    /// The shared instance of the SSSpeechManager class
    static let sharedManager = SSSpeechManager()
    
    fileprivate override init() {}
    
    /* 
        The AVSpeechSynthesizer
    */
    var speechSynthesizer: AVSpeechSynthesizer {
        if _speechSynthesizer == nil {
            _speechSynthesizer = AVSpeechSynthesizer()
            _speechSynthesizer!.delegate = self
        }
        return _speechSynthesizer!
    }
    var _speechSynthesizer: AVSpeechSynthesizer? = nil
    
    /*
        Array of language codes, sorted alphabetically
    */
    var languageCodes: [String] {
        if _languageCodes == nil {
        
            // Cast the Dictionary to NSDictionary
            // Then wen can use the keysSortedByValueUsingSelector method to sort the keys by value (language display name)
        
            _languageCodes = (languageCodesAndDisplayNames as NSDictionary).keysSortedByValue(using: #selector(NSNumber.compare(_:))) as? [String]
        
            // If sorting the language codes (keys) was enough, we could have used the sort() method like below,
            // but instead we want the language codes (keys) sorted by their language display names (values)
            /*
            // Fill _languageCodes with keys from languageCodesAndDisplayNames
        
            _languageCodes = Array(languageCodesAndDisplayNames.keys)
        
            // Sort codes alphabetically. For the predicate parameter we can use < as the shortest notation and is the same as { $1 < $2 }
        
            _languageCodes = sort(_languageCodes!, < )
            */
        
        }
        return _languageCodes!
    }
    var _languageCodes: [String]? = nil
    
    /*
        A dictionary holding <language code/display names> key/value pairs with locale taken into account
    */
    var languageCodesAndDisplayNames: Dictionary<String, String> {
        if _languageCodesAndDisplayNames == nil {
            
            _languageCodesAndDisplayNames = Dictionary<String, String>()
            
            var languageCodes: [String] = Array()
            
            let speechVoices: [AnyObject]? = AVSpeechSynthesisVoice.speechVoices()
            
            if let speechVcs = speechVoices {
                
                for voice: AnyObject in speechVcs {
                    
                    languageCodes.append((voice as! AVSpeechSynthesisVoice).language)
                    
                    let currentLocale: Locale = Locale.autoupdatingCurrent
                    
                    var dictionary = Dictionary<String, String>()
                    for languageCode in languageCodes {
                        dictionary[languageCode] = (currentLocale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: languageCode)
                    }
                    
                    _languageCodesAndDisplayNames = dictionary
                    
                }
            }
            
        }
        return _languageCodesAndDisplayNames!
    }
    var _languageCodesAndDisplayNames: Dictionary<String, String>? = nil
    
    
    func speakWithSpeechObject(_ speechObject: SSSpeechObject) {
        
        Answers.logCustomEvent(withName: "speakWithSpeechObject", customAttributes: ["language": speechObject.language, "rate":speechObject.rate, "pitch": speechObject.pitch, "text": speechObject.speechString])
        
        var speechUtterance : AVSpeechUtterance
        speechUtterance = AVSpeechUtterance(string: speechObject.speechString)
        speechUtterance.rate = speechObject.rate
        speechUtterance.pitchMultiplier = speechObject.pitch
        
        var speechSynthesisVoice : AVSpeechSynthesisVoice
        speechSynthesisVoice = AVSpeechSynthesisVoice(language: speechObject.language)!
        speechUtterance.voice = speechSynthesisVoice
        
        speechSynthesizer.speak(speechUtterance)
        
    }
    
    /*
        AVSpeechSynthesizerDelegate methods
    */
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        print("SSSpeechManager speechSynthesizer: didStartSpeechUtterance:")
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        print("SSSpeechManager speechSynthesizer: didFinishSpeechUtterance:")
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        
        print("SSSpeechManager speechSynthesizer: didCancelSpeechUtterance:")
        
    }
    
}
