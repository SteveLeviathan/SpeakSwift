//
//  InterfaceController.swift
//  SpeakSwift WatchKit Extension
//
//  Created by Steve Overmars on 19-07-15.
//  Copyright (c) 2015 Appify Media. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var speechesTable: WKInterfaceTable!
    @IBOutlet var noFavouritesGroup: WKInterfaceGroup!

    var speechObjects: [SSSpeechObject] = []

    var receivedData: [String : Any]!

    let speechManager = SSSpeechManager.shared
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        setTitle("SpeakSwift")

        let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
        watchDelegate?.subscribe(listener: self)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
        watchDelegate?.fetchData()

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if rowIndex < speechObjects.count {
            let speechObject = speechObjects[rowIndex]
            
            speakText(speechObject)
        }
    }
    
    func speakText(_ speechObject: SSSpeechObject) {
        if speechManager.speechSynthesizer.isSpeaking {
            // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
            speechManager.speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        // Check if sharedSpeechManager.languageCodesAndDisplayNames dictionary has entries, if not this means there are no speech voices available on the device. (e.g.: The iPhone Simulator)
        if !speechManager.languageCodesAndDisplayNames.isEmpty {
            speechManager.speakWithSpeechObject(speechObject)
        }
    }

}

extension InterfaceController: WCSessionDelegateListening {

    func receivedData(_ data: [String : Any]) {
        receivedData = data
        reloadTableView()
    }

    func reloadTableView() {
        // Load saved Speech Objects
        guard let data = receivedData else { return }

        speechObjects = speechObjects(from: data["speeches"] as! [[String: String]])

        let speechObjectsCount = speechObjects.count
        if speechObjectsCount > 0 {
            noFavouritesGroup.setHidden(true)
        }

        speechesTable.setNumberOfRows(speechObjectsCount, withRowType: "SpeechesRow")
        for (index, speechObject) in speechObjects.enumerated() {
            if let row = speechesTable.rowController(at: index) as? SpeechesRowController {
                row.speechLabel.setText(speechObject.speechString)
                row.imageView.setImageNamed("sound")
            }
        }
    }

    func speechObjects(from array: [[String: String]]) -> [SSSpeechObject] {

        var speechObjectsArray: [SSSpeechObject] = []

        for speechObjectDictionary in array {

            speechObjectsArray.append(SSSpeechObject.speechObjectFromDictionary(dictionary: speechObjectDictionary))

        }

        return speechObjectsArray
    }

}
