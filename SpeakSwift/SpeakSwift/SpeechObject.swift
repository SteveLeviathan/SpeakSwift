//
//  SpeechObject.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 08-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import Foundation

class SpeechObject {
   
    var rate: Float = 1.0
    var pitch: Float = 1.0
    var language  = ""
    var volume: Float = 1.0
    var speechString = ""

    /// Returns a SpeechObject with data from input parameters
    
    class func speechObjectWith(speechString: String, language: String, rate: Float, pitch: Float, volume: Float) -> SpeechObject {
        
        let speechObject = SpeechObject()
        
        speechObject.speechString = speechString
        speechObject.language = language
        speechObject.rate = rate
        speechObject.pitch = pitch
        speechObject.volume = volume
        
        return speechObject

    }
    
    /// Returns a SpeechObject from a Dictionary
    
    class func speechObjectFromDictionary(dictionary: [String: String]?) -> SpeechObject {

        guard let dict = dictionary else { return SpeechObject() }

        let speechString = dict["speechString"]!
        let language = dict["language"]!
        let rateStr = dict["rate"]!
        let pitchStr = dict["pitch"]!
        let volumeStr = dict["volume"]!

        let rate =  Float(rateStr)
        let pitch = Float(pitchStr)
        let volume = Float(volumeStr)

        let speechObject = speechObjectWith(
            speechString: speechString,
            language: language,
            rate: rate!,
            pitch: pitch!,
            volume: volume!
        )

        return speechObject
        
    }
    
    
    /// Returns a Dictionary representation of a SpeechObject
    
    func dictionaryRepresentation () -> [String: String] {
        
        var dictionary: [String: String] = [:]
        dictionary.updateValue(speechString, forKey: "speechString")
        dictionary.updateValue(language, forKey: "language")
        dictionary.updateValue(String(format: "%.2f", rate) , forKey: "rate")
        dictionary.updateValue(String(format: "%.2f", pitch) , forKey: "pitch")
        dictionary.updateValue(String(format: "%.2f", volume) , forKey: "volume")
        
        return dictionary
        
    }
    
}
