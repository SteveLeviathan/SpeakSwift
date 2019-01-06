//
//  SSDataManager.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 08-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity

let SpeakSwiftSpeechObjectsKey = "SpeakSwift.SpeechObjects"

class SSDataManager {
    
    var speechObjects: [SSSpeechObject] = []

    /// The shared instance of the SSDataManager class
    static let shared = SSDataManager()
    
    fileprivate init() {}
    
    /// Add a single SSSpeechObject to the working array speechObjects
    
    func addSpeechObject(speechObject: SSSpeechObject) {
        
        // Add SSSpeechObject to the top of the list
        speechObjects.insert(speechObject, at: 0)

        saveSpeechObjects()

    }
    
    
    
    /// Convert a single SSSpeechObject to Dictionary, add it to the other saved Speech Object Dictionaries and save them to NSUserDefaults.standardUserDefaults()
    
    func saveSpeechObject(speechObject: SSSpeechObject?) {
        
        if let speechObj = speechObject {
            
            var savedObjects = speechObjectDictionariesArray()
            
            // Add Speech Object Dictionary to the top of the list
            savedObjects.insert(speechObj.dictionaryRepresentation(), at: 0)
            
            // Save Speech Object Dictionaries to NSUserDefaults.standardUserDefaults()
            
            saveSpeechObjectDictionaries(savedObjects)
            
            // Clear working array speechObjects
            
            speechObjects.removeAll(keepingCapacity: false)
            
            // Add saved SSSpeechObjects to working array speechObjects
            
            speechObjects += SSDataManager.shared.savedSpeechObjects()
            
        }
        
    }
    
    
    /* 
        Load Speech Object Dictionaries from NSUserDefaults.standardUserDefaults()
    */
    func speechObjectDictionariesArray() -> [[String: String]] {
        
        // Return an array of speech object dictionaries if there are any.
        let sharedUserDefaults = UserDefaults(suiteName: "group.speakswift.speechdata")!
        if let data = sharedUserDefaults.object(forKey: SpeakSwiftSpeechObjectsKey) as? Data {
            
            let arrayOfSpeechObjectDictionaries = NSKeyedUnarchiver.unarchiveObject(with: data) as! [[String: String]]
            return arrayOfSpeechObjectDictionaries
            
        }

        return []
        
    }
    
    
    /* 
        Returns saved Speech Object Dictionaries as an Array of SSSpeechObjects
    */
    func savedSpeechObjects() -> [SSSpeechObject] {
        
        var speechObjectsArray: [SSSpeechObject] = []
        
        for speechObjectDictionary in speechObjectDictionariesArray() {
            
            speechObjectsArray.append(SSSpeechObject.speechObjectFromDictionary(dictionary: speechObjectDictionary))
            
        }
        
        return speechObjectsArray
    }

    func speechObjects(from array: [[String: String]]) -> [SSSpeechObject] {

        var speechObjectsArray: [SSSpeechObject] = []

        for speechObjectDictionary in array {

            speechObjectsArray.append(SSSpeechObject.speechObjectFromDictionary(dictionary: speechObjectDictionary))

        }

        return speechObjectsArray
    }
    
    
    /* 
        Convert SSSpeechObjects to Dictionaries and save to NSUserDefaults.standardUserDefaults()
    */
    func saveSpeechObjects() {
    
        var speechObjectsAsDictionaries: [[String: String]] = []
        
        for speechObject: SSSpeechObject in speechObjects {
            
            speechObjectsAsDictionaries.append(speechObject.dictionaryRepresentation())
            
        }
        
        saveSpeechObjectDictionaries(speechObjectsAsDictionaries)

        if (WCSession.isSupported()) {
            let session = WCSession.default

            guard session.activationState == .activated else { return }

            if !session.isPaired {
                print("Apple Watch is not paired")
                return
            }

            if !session.isWatchAppInstalled{
                print("WatchKit app is not installed")
                return
            }

            session.sendMessage(["speeches": speechObjectsAsDictionaries], replyHandler: { reply in
                print(reply)
            })

        } else {
            print("WatchConnectivity is not supported on this device")
        }
    }

    
    /*
        Save Speech Object Dictionaries to NSUserDefaults.standardUserDefaults()
    */
    func saveSpeechObjectDictionaries(_ dictionaries: [[String: String]]) {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: dictionaries)
        
        let sharedUserDefaults = UserDefaults(suiteName: "group.speakswift.speechdata")!
        
        sharedUserDefaults.set(data, forKey: SpeakSwiftSpeechObjectsKey)
        
        sharedUserDefaults.synchronize()
        
    }

}
