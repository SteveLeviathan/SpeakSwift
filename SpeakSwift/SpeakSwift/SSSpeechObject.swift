//
//  SSSpeechObject.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 08-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import Foundation

class SSSpeechObject {
   
    var rate : CFloat = 1.0
    var pitch : CFloat = 1.0
    var language : String = ""
    var volume : CFloat = 1.0
    var speechString : String = ""
    
    init () {
        print("SSSpeechObject init()")
    }
    
    /// Returns a SSSpeechObject with data from input parameters
    
    class func speechObjectWith(speechString speechString: String, language: String, rate: CFloat, pitch: CFloat, volume: CFloat) -> SSSpeechObject {
        
        let speechObject = SSSpeechObject()
        
        speechObject.speechString = speechString
        speechObject.language = language
        speechObject.rate = rate
        speechObject.pitch = pitch
        speechObject.volume = volume
        
        return speechObject
    }
    
    /// Returns a SSSpeechObject from a Dictionary
    
    class func speechObjectFromDictionary(dictionary dictionary: Dictionary<String, String>?) -> SSSpeechObject {
        
        if let dict: Dictionary<String, String> = dictionary {
            
            let speechString : String = dict["speechString"]!
            let language : String = dict["language"]!
            let rateStr : String = dict["rate"]!
            let pitchStr : String = dict["pitch"]!
            let volumeStr : String = dict["volume"]!
            
            // String to CFloat conversion using bridgeToObjectiveC()
            let rate = (rateStr as NSString).floatValue
            let pitch = (pitchStr as NSString).floatValue
            let volume = (volumeStr as NSString).floatValue
            
            let speechObject = speechObjectWith(speechString: speechString, language: language, rate: rate, pitch: pitch, volume: volume)
            
            return speechObject
        }
        return SSSpeechObject()
        
        
    }
    
    
    /// Returns a Dictionary representation of a SSSPeechObject
    
    func dictionaryRepresentation () -> Dictionary<String, String> {
        
        var dictionary: Dictionary<String, String> = Dictionary()
        dictionary.updateValue(speechString, forKey: "speechString")
        dictionary.updateValue(language, forKey: "language")
        dictionary.updateValue(String(format: "%.2f", rate) , forKey: "rate")
        dictionary.updateValue(String(format: "%.2f", pitch) , forKey: "pitch")
        dictionary.updateValue(String(format: "%.2f", volume) , forKey: "volume")
        
        return dictionary
        
    }
    
}
