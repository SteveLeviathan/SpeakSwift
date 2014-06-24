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
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return SSDataManager.sharedManager.speechObjects.count
    }
    
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return SSSavedSpeechTableViewCell.cellHeight()
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cellIdentifer = "SavedSpeechTableViewCellIdentifier"
        var cell: SSSavedSpeechTableViewCell? = nil //tableView!.dequeueReusableCellWithIdentifier(cellIdentifer) as? SSSavedSpeechTableViewCell
        
        if SSDataManager.sharedManager.speechObjects.count > 0 {
            
            let speechObject : SSSpeechObject = SSDataManager.sharedManager.speechObjects[indexPath.row]
            
            cell = SSSavedSpeechTableViewCell(speechObject: speechObject, reuseIdentifier: cellIdentifer)
            
            
        } else {
            
            cell = SSSavedSpeechTableViewCell(style: .Default, reuseIdentifier: cellIdentifer)
            
        }
        
        // Set the delegate to self so it responds to SSSavedSpeechTableViewCellDelegate methods
        cell!.delegate = self
        
        cell!.tableView = tableView
        
        return cell
    }
    
    
    /*
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    
        navigationController.popViewControllerAnimated(true)
    
    }
    */
    
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        if editingStyle == .Delete {
            
            SSDataManager.sharedManager.speechObjects.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        
    }
    
    /*
        AVSpeechSynthesizerDelegate methods
    */
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        
        println("SSSavedSpeechObjectsTableViewController speechSynthesizer: didStartSpeechUtterance:")
        
        AppDelegate.appDelegate().mainViewController!.speakButton!.titleLabel.text = "Stop!"
        
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        
        println("SSSavedSpeechObjectsTableViewController speechSynthesizer: didFinishSpeechUtterance:")
        
        AppDelegate.appDelegate().mainViewController!.speakButton!.titleLabel.text = "Speak!"
        
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didCancelSpeechUtterance utterance: AVSpeechUtterance!) {
        
        println("SSSavedSpeechObjectsTableViewController speechSynthesizer: didCancelSpeechUtterance:")
        
        AppDelegate.appDelegate().mainViewController!.speakButton!.titleLabel.text = "Speak!"
        
    }
    
    /*
        SSSavedSpeechTableViewCellDelegate methods
    */
    
    func playButtonTappedOnSavedSpeechTableViewCell(savedSpeechTableViewCell: SSSavedSpeechTableViewCell!, withIndexPath indexPath: NSIndexPath!) {
        
        println("savedSpeechTableViewCell playButtonTappedOn withIndexPath")
        
        if SSSpeechManager.sharedManager.languageCodesAndDisplayNames.count > 0 {
            
            let speechObject : SSSpeechObject = SSDataManager.sharedManager.speechObjects[indexPath.row]
            
            SSSpeechManager.sharedManager.speechSynthesizer.delegate = self
            
            SSSpeechManager.sharedManager.speakWithSpeechObject(speechObject)
            
        }
        
    }
    
    func editButtonTappedOnSavedSpeechTableViewCell(savedSpeechTableViewCell: SSSavedSpeechTableViewCell!, withIndexPath indexPath: NSIndexPath!) {
        
        println("editButtonTappedOn withIndexPath")
        
        self.navigationController.popViewControllerAnimated(true)
        
        let speechObject: SSSpeechObject = SSDataManager.sharedManager.speechObjects[indexPath.row]
        
        AppDelegate.appDelegate().mainViewController!.updateUIControlsWithSpeechObject(speechObject)
        
    }
    
}
