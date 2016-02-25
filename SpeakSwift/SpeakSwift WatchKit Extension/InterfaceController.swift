//
//  InterfaceController.swift
//  SpeakSwift WatchKit Extension
//
//  Created by Steve Overmars on 19-07-15.
//  Copyright (c) 2015 Appify Media. All rights reserved.
//

import WatchKit
import Foundation
import Crashlytics

class InterfaceController: WKInterfaceController {

    
    @IBOutlet var speechesTable: WKInterfaceTable!
    @IBOutlet var noFavouritesGroup: WKInterfaceGroup!
    
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        setTitle("SpeakSwift")
    }

    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        Answers.logCustomEventWithName("Apple Watch Main Interface Activated", customAttributes: nil)
        
        // Load saved Speech Objects
        SSDataManager.sharedManager.speechObjects = SSDataManager.sharedManager.savedSpeechObjects()
        
        let speechObjectsCount : Int = SSDataManager.sharedManager.speechObjects.count;
        if speechObjectsCount > 0
        {
            noFavouritesGroup.setHidden(true)
        }
        speechesTable.setNumberOfRows(speechObjectsCount, withRowType: "SpeechesRow")
        for (index, speechObject) in SSDataManager.sharedManager.speechObjects.enumerate()
        {
            if let row = speechesTable.rowControllerAtIndex(index) as? SpeechesRowController
            {
                row.speechLabel.setText(speechObject.speechString)
                row.imageView.setImageNamed("sound")
            }
        }
    }

    override func didDeactivate()
    {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int)
    {
        print("didSelectRowAtIndex: \(rowIndex)")
        if rowIndex < SSDataManager.sharedManager.speechObjects.count
        {
            let speechObject : SSSpeechObject = SSDataManager.sharedManager.speechObjects[rowIndex]
            
            speakText(speechObject)
        }
        
    }
    
    func speakText(speechObject: SSSpeechObject)
    {
        print("speakText: \(speechObject.speechString)")
        
        if SSSpeechManager.sharedManager.speechSynthesizer.speaking
        {
            // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
            SSSpeechManager.sharedManager.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
        }
        // Check if sharedSpeechManager.languageCodesAndDisplayNames dictionary has entries, if not this means there are no speech voices available on the device. (e.g.: The iPhone Simulator)
        if SSSpeechManager.sharedManager.languageCodesAndDisplayNames.count > 0
        {
            SSSpeechManager.sharedManager.speakWithSpeechObject(speechObject)
        }
    }

}
