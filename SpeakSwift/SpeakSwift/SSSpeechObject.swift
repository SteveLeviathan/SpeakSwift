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
        println("SSSpeechObject init()")
    }
    
    
    class func speechObjectWith(#speechString: String?, language: String?, rate: CFloat?, pitch: CFloat?, volume: CFloat?) -> SSSpeechObject {
        
        var speechObject = SSSpeechObject()
        
        speechObject.speechString = speechString!
        speechObject.language = language!
        speechObject.rate = rate!
        speechObject.pitch = pitch!
        speechObject.volume = volume!
        
        return speechObject
    }
    
    
    class func speechObjectFromDictionary(#dictionary: Dictionary<String, String>?) -> SSSpeechObject {
        
        if let dict: Dictionary<String, String> = dictionary {
            
            let speechString : String = dict["speechString"]!
            let language : String = dict["language"]!
            let rateStr : String = dict["rate"]!
            let pitchStr : String = dict["pitch"]!
            let volumeStr : String = dict["volume"]!
            
            // String to CFloat conversion using bridgeToObjectiveC()
            let rate = rateStr.bridgeToObjectiveC().floatValue
            let pitch = pitchStr.bridgeToObjectiveC().floatValue
            let volume = volumeStr.bridgeToObjectiveC().floatValue
            
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
        dictionary.updateValue(String(rate), forKey: "rate")
        dictionary.updateValue(String(pitch), forKey: "pitch")
        dictionary.updateValue(String(volume), forKey: "volume")
        
        return dictionary
        
    }
    
}
