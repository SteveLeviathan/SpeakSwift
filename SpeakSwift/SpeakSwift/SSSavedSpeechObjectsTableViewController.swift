//
//  SSSavedSpeechObjectsTableViewController.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 09-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit
import AVFoundation

class SSSavedSpeechObjectsTableViewController: UITableViewController, AVSpeechSynthesizerDelegate, SSSavedSpeechTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favourites"
        
        tableView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        
        tableView.separatorColor = contrastingColor
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SSDataManager.sharedManager.speechObjects.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SSSavedSpeechTableViewCell.cellHeight()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifer = "SavedSpeechTableViewCellIdentifier"
        var cell: SSSavedSpeechTableViewCell? = nil //tableView!.dequeueReusableCellWithIdentifier(cellIdentifer) as? SSSavedSpeechTableViewCell
        
        if SSDataManager.sharedManager.speechObjects.count > 0 {
            
            let speechObject : SSSpeechObject = SSDataManager.sharedManager.speechObjects[indexPath.row]
            
            cell = SSSavedSpeechTableViewCell(speechObject: speechObject, reuseIdentifier: cellIdentifer)
            
            
        } else {
            
            cell = SSSavedSpeechTableViewCell(style: .default, reuseIdentifier: cellIdentifer)
            
        }
        
        // Set the delegate to self so it responds to SSSavedSpeechTableViewCellDelegate methods
        cell!.delegate = self
        
        cell!.tableView = tableView
        
        return cell!
    }
    
    
    /*
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    
        navigationController.popViewControllerAnimated(true)
    
    }
    */
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            SSDataManager.sharedManager.speechObjects.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    /*
        AVSpeechSynthesizerDelegate methods
    */
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        print("SSSavedSpeechObjectsTableViewController speechSynthesizer: didStartSpeechUtterance:")
        
        AppDelegate.appDelegate().mainViewController!.speakButton!.titleLabel?.text = "Stop!"
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        print("SSSavedSpeechObjectsTableViewController speechSynthesizer: didFinishSpeechUtterance:")
        
        AppDelegate.appDelegate().mainViewController!.speakButton!.titleLabel?.text = "Speak!"
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        
        print("SSSavedSpeechObjectsTableViewController speechSynthesizer: didCancelSpeechUtterance:")
        
        AppDelegate.appDelegate().mainViewController!.speakButton!.titleLabel?.text = "Speak!"
        
    }
    
    /*
        SSSavedSpeechTableViewCellDelegate methods
    */
    
    func playButtonTappedOnSavedSpeechTableViewCell(_ savedSpeechTableViewCell: SSSavedSpeechTableViewCell!, withIndexPath indexPath: IndexPath!) {
        
        print("savedSpeechTableViewCell playButtonTappedOn withIndexPath")
        
        if SSSpeechManager.sharedManager.speechSynthesizer.isSpeaking
        {
            // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
            SSSpeechManager.sharedManager.speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        if SSSpeechManager.sharedManager.languageCodesAndDisplayNames.count > 0 {
            
            let speechObject : SSSpeechObject = SSDataManager.sharedManager.speechObjects[indexPath.row]
            
            SSSpeechManager.sharedManager.speechSynthesizer.delegate = self
            
            SSSpeechManager.sharedManager.speakWithSpeechObject(speechObject)
            
        }
        
    }
    
    func editButtonTappedOnSavedSpeechTableViewCell(_ savedSpeechTableViewCell: SSSavedSpeechTableViewCell!, withIndexPath indexPath: IndexPath!) {
        
        print("editButtonTappedOn withIndexPath")
        
        self.navigationController?.popViewController(animated: true)
        let speechObject: SSSpeechObject = SSDataManager.sharedManager.speechObjects[indexPath.row]
        
        AppDelegate.appDelegate().mainViewController!.updateUIControlsWithSpeechObject(speechObject)
        
    }
    
}
