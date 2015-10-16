//
//  SSDataManager.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 08-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit

/* sharedDataManager
    Global constant that can be used as the shared instance of the SSDataManager class
    Globals are lazy loaded.
*/
//let sharedDataManager = SSDataManager()

let SpeakSwiftSpeechObjectsKey = "SpeakSwift.SpeechObjects"

class SSDataManager : NSObject {
    
    var speechObjects: [SSSpeechObject] = Array()
    
    /// The shared instance of the SSDataManager class
    
    class var sharedManager: SSDataManager {

        struct Static {
            static let sharedInstance : SSDataManager = SSDataManager()
        }
            
        return Static.sharedInstance
    }
    
    override init() {
        print("SSDataManager init()")
    }
    
    
    
    /// Add a single SSSpeechObject to the working array speechObjects
    
    func addSpeechObject(speechObject speechObject : SSSpeechObject) {
        
        // Add SSSpeechObject to the top of the list
        speechObjects.insert(speechObject, atIndex: 0)
        
    }
    
    
    
    /// Convert a single SSSpeechObject to Dictionary, add it to the other saved Speech Object Dictionaries and save them to NSUserDefaults.standardUserDefaults()
    
    func saveSpeechObject(speechObject speechObject : SSSpeechObject?) {
        
        if let speechObj = speechObject {
            
            var savedObjects : [Dictionary<String, String>] = speechObjectDictionariesArray()
            
            // Add Speech Object Dictionary to the top of the list
            savedObjects.insert(speechObj.dictionaryRepresentation(), atIndex: 0)
            
            // Save Speech Object Dictionaries to NSUserDefaults.standardUserDefaults()
            
            saveSpeechObjectDictionaries(savedObjects)
            
            // Clear working array speechObjects
            
            speechObjects.removeAll(keepCapacity: false)
            
            // Add saved SSSpeechObjects to working array speechObjects
            
            speechObjects += SSDataManager.sharedManager.savedSpeechObjects()
            
        }
        
    }
    
    
    /* 
        Load Speech Object Dictionaries from NSUserDefaults.standardUserDefaults()
    */
    func speechObjectDictionariesArray() -> [Dictionary<String, String>] {
        
        // Return an array of speech object dictionaries if there are any.
        
        if let data: NSData = NSUserDefaults.standardUserDefaults().objectForKey(SpeakSwiftSpeechObjectsKey) as? NSData {
            
            let arrayOfSpeechObjectDictionaries: [Dictionary<String, String>] = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Dictionary<String, String>]
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
    func saveSpeechObjectDictionaries(dictionaries: [Dictionary<String, String>]) {
        
        let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(dictionaries)
        
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: SpeakSwiftSpeechObjectsKey)
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    
    
}



