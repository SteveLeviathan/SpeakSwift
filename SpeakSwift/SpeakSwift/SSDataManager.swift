//
//  SSDataManager.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 08-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit

let SpeakSwiftSpeechObjectsKey = "SpeakSwift.SpeechObjects"

class SSDataManager : NSObject {
    
    var speechObjects: [SSSpeechObject] = Array()
    
    /// The shared instance of the SSDataManager class
    static let sharedManager = SSDataManager()
    
    fileprivate override init() {}
    
    /// Add a single SSSpeechObject to the working array speechObjects
    
    func addSpeechObject(speechObject : SSSpeechObject) {
        
        // Add SSSpeechObject to the top of the list
        speechObjects.insert(speechObject, at: 0)
        
    }
    
    
    
    /// Convert a single SSSpeechObject to Dictionary, add it to the other saved Speech Object Dictionaries and save them to NSUserDefaults.standardUserDefaults()
    
    func saveSpeechObject(speechObject : SSSpeechObject?) {
        
        if let speechObj = speechObject {
            
            var savedObjects : [Dictionary<String, String>] = speechObjectDictionariesArray()
            
            // Add Speech Object Dictionary to the top of the list
            savedObjects.insert(speechObj.dictionaryRepresentation(), at: 0)
            
            // Save Speech Object Dictionaries to NSUserDefaults.standardUserDefaults()
            
            saveSpeechObjectDictionaries(savedObjects)
            
            // Clear working array speechObjects
            
            speechObjects.removeAll(keepingCapacity: false)
            
            // Add saved SSSpeechObjects to working array speechObjects
            
            speechObjects += SSDataManager.sharedManager.savedSpeechObjects()
            
        }
        
    }
    
    
    /* 
        Load Speech Object Dictionaries from NSUserDefaults.standardUserDefaults()
    */
    func speechObjectDictionariesArray() -> [Dictionary<String, String>] {
        
        // Return an array of speech object dictionaries if there are any.
        let sharedUserDefaults : UserDefaults = UserDefaults(suiteName: "group.speakswift.speechdata")!
        if let data: Data = sharedUserDefaults.object(forKey: SpeakSwiftSpeechObjectsKey) as? Data {
            
            let arrayOfSpeechObjectDictionaries: [Dictionary<String, String>] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Dictionary<String, String>]
            return arrayOfSpeechObjectDictionaries
            
        }
        
        // If there are no Speech Object Dictionaries, return an empty array
        
        return [Dictionary<String, String>]()
        
    }
    
    
    /* 
        Returns saved Speech Object Dictionaries as an Array of SSSpeechObjects
    */
    func savedSpeechObjects() -> [SSSpeechObject] {
        
        var speechObjectsArray: [SSSpeechObject] = Array()
        
        let arrayOfSpeechObjectDictionaries: [Dictionary<String, String>] = speechObjectDictionariesArray()
        
        for speechObjectDictionary: Dictionary<String, String> in arrayOfSpeechObjectDictionaries {
            
            speechObjectsArray.append(SSSpeechObject.speechObjectFromDictionary(dictionary: speechObjectDictionary))
            
        }
        
        return speechObjectsArray
    }
    
    
    /* 
        Convert SSSpeechObjects to Dictionaries and save to NSUserDefaults.standardUserDefaults()
    */
    func saveSpeechObjects() {
    
        var speechObjectsAsDictionaries: [Dictionary<String, String>] = Array()
        
        for speechObject: SSSpeechObject in speechObjects {
            
            speechObjectsAsDictionaries.append(speechObject.dictionaryRepresentation())
            
        }
        
        saveSpeechObjectDictionaries(speechObjectsAsDictionaries)
    }
    
    
    /*
        Save Speech Object Dictionaries to NSUserDefaults.standardUserDefaults()
    */
    func saveSpeechObjectDictionaries(_ dictionaries: [Dictionary<String, String>]) {
        
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: dictionaries)
        
        let sharedUserDefaults : UserDefaults = UserDefaults(suiteName: "group.speakswift.speechdata")!
        
        sharedUserDefaults.set(data, forKey: SpeakSwiftSpeechObjectsKey)
        
        sharedUserDefaults.synchronize()
        
    }
    
    
    
}



