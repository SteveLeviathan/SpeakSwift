//
//  SpeechObject.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 08-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import Foundation

struct SpeechObject {

    let speechString: String
    let language: String
    let rate: Float
    let pitch: Float
    let volume: Float

    init(speechString: String = "",
         language: String = "",
         rate: Float = 1.0,
         pitch: Float = 1.0,
         volume: Float = 1.0) {

        self.speechString = speechString
        self.language = language
        self.rate = rate
        self.pitch = pitch
        self.volume = volume

    }
    
    /// Returns a SpeechObject from a Dictionary
    
    init(dictionary: [String: String]) {
        let speechString = dictionary["speechString"] ?? ""
        let language = dictionary["language"] ?? ""
        let rateStr = dictionary["rate"] ?? "1.0"
        let pitchStr = dictionary["pitch"] ?? "1.0"
        let volumeStr = dictionary["volume"] ?? "1.0"

        let rate =  Float(rateStr) ?? 1.0
        let pitch = Float(pitchStr) ?? 1.0
        let volume = Float(volumeStr) ?? 1.0

        self.speechString = speechString
        self.language = language
        self.rate = rate
        self.pitch = pitch
        self.volume = volume

    }

    /// Returns a Dictionary representation of a SpeechObject
    
    func dictionaryRepresentation () -> [String: String] {
        
        var dictionary: [String: String] = [:]

        dictionary["speechString"] = speechString
        dictionary["language"] = language
        dictionary["rate"] = String(format: "%.2f", rate)
        dictionary["pitch"] = String(format: "%.2f", pitch)
        dictionary["volume"] = String(format: "%.2f", volume)

        return dictionary
        
    }
    
}
