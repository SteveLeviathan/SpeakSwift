//
//  SSSavedSpeechTableViewCell.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 12-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit

class SSSavedSpeechTableViewCell: UITableViewCell {
    
    typealias ButtonTappedBlockType = () -> ()
    
    var playButton: UIButton? = nil
    
    var editButton: UIButton? = nil
    
    var speechTextLabel: UILabel? = nil
    var voiceRateLabel: UILabel? = nil
    var voicePitchLabel: UILabel? = nil
    var languageLabel: UILabel? = nil
    
    var delegate: SSSavedSpeechTableViewCellDelegate?
    
    var tableView: UITableView? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialization code
        
        backgroundColor = UIColor.clearColor()
        
        selectionStyle = .None
        
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: SSSavedSpeechTableViewCell.cellHeight())
        
        setUpLabelAndButtons()
        
    }
    
    
    init(speechObject: SSSpeechObject, reuseIdentifier: String) {
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        selectionStyle = .None
        
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: SSSavedSpeechTableViewCell.cellHeight())
        
        setUpLabelAndButtons()
        
        populateWithSpeechObject(speechObject)
        
    }
    
    /// Set up label and buttons
    
    func setUpLabelAndButtons() {
        
        speechTextLabel = UILabel(frame: CGRect(x: 20.0, y: 10.0, width: CGRectGetWidth(contentView.frame) - 40.0, height: 60.0))
        speechTextLabel!.textColor = contrastingColor
        speechTextLabel!.textAlignment = .Left
        speechTextLabel!.font = UIFont(name: "Helvetica Neue", size: 12.0)
        speechTextLabel!.numberOfLines = 4
        
        contentView.addSubview(speechTextLabel!)
        
        voiceRateLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 15.0))
        voiceRateLabel!.textColor = contrastingColor
        voiceRateLabel!.textAlignment = .Left
        voiceRateLabel!.font = UIFont(name: "Helvetica Neue", size: 12.0)
        
        // Call UIView positioning extension method positionBelowView() on voiceRateLabel
        voiceRateLabel?.positionBelowView(speechTextLabel!, xOffset: 0.0, yOffset: 10.0)
        
        contentView.addSubview(voiceRateLabel!)
        
        voicePitchLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 15.0))
        voicePitchLabel!.textColor = contrastingColor
        voicePitchLabel!.textAlignment = .Left
        voicePitchLabel!.font = UIFont(name: "Helvetica Neue", size: 12.0)
        
        // Call UIView positioning extension method positionBelowView() on voiceRateLabel
        voicePitchLabel?.positionRightFromView(voiceRateLabel!, xOffset: 20.0, yOffset: 0.0)
        
        contentView.addSubview(voicePitchLabel!)
        
        languageLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: CGRectGetWidth(contentView.frame) - 40.0, height: 15.0))
        languageLabel!.textColor = contrastingColor
        languageLabel!.textAlignment = .Left
        languageLabel!.font = UIFont(name: "Helvetica Neue", size: 12.0)
        
        // Call UIView positioning extension method positionBelowView() on languageLabel
        languageLabel?.positionBelowView(voiceRateLabel!, xOffset: 0.0, yOffset: 5.0)
        
        contentView.addSubview(languageLabel!)
        
        playButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 30.0))
        playButton!.backgroundColor = UIColor(white: 0.10, alpha: 1.0)
        playButton?.setTitle("Play", forState: .Normal)
        playButton?.setTitleColor(contrastingColor, forState: .Normal)
        playButton!.layer.borderWidth = 1.0
        playButton!.layer.borderColor = contrastingColor.CGColor
        playButton?.addTarget(self, action: Selector("playButtonTapped:"), forControlEvents: .TouchUpInside)
        
        // Call UIView positioning extension method positionBelowView() on playButton
        playButton!.positionBelowView(languageLabel!, xOffset: 0.0, yOffset: 20.0)
        
        contentView.addSubview(playButton!)
        
        editButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 30.0))
        editButton!.backgroundColor = UIColor(white: 0.10, alpha: 1.0)
        editButton?.setTitle("Edit", forState: .Normal)
        editButton?.setTitleColor(contrastingColor, forState: .Normal)
        editButton!.layer.borderWidth = 1.0
        editButton!.layer.borderColor = contrastingColor.CGColor
        editButton?.addTarget(self, action: Selector("editButtonTapped:"), forControlEvents: .TouchUpInside)
        
        // Call UIView positioning extension method positionRightFromView() on editButton
        editButton!.positionRightFromView(playButton!, xOffset: 20.0, yOffset: 0.0)
        
        contentView.addSubview(editButton!)
        
        
    }
    
    /// Populate this SSSavedSpeechTableViewCell with SSSpeechObject data
    
    func populateWithSpeechObject (speechObject : SSSpeechObject) {
        
        if let speechTextLbl: UILabel = speechTextLabel {
            
            speechTextLbl.text = speechObject.speechString
            
        }
        
        if let voiceRateLbl: UILabel = voiceRateLabel {
            
            voiceRateLbl.text = String(format: "Rate: %.2f", speechObject.rate)
            
        }
        
        if let voicePitchLbl: UILabel = voicePitchLabel {
            
            voicePitchLbl.text = String(format: "Pitch: %.2f", speechObject.pitch)
            
        }
        
        if let languageLbl: UILabel = languageLabel {
            
            languageLbl.text = "Language: \(SSSpeechManager.sharedManager.languageCodesAndDisplayNames[speechObject.language]!)"
            
        }
        
    }
    
    
    /// Return this cell's height

    class func cellHeight() -> CGFloat {
        
        return 180.0;
        
    }
    
    /// Perform action when the Play button is tapped
    
    func playButtonTapped(sender: UIButton!) {
        
        if let tblView: UITableView = tableView {
            
            let indexPath: NSIndexPath = tblView.indexPathForCell(self)!
            
            delegate?.playButtonTappedOnSavedSpeechTableViewCell(self, withIndexPath: indexPath)
            
        }
        
        
    }
    
    /// Perform action when the Edit button is tapped
    
    func editButtonTapped(sender: UIButton!) {
        
        if let tblView: UITableView = tableView {
            
            let indexPath: NSIndexPath = tblView.indexPathForCell(self)!
            
            delegate?.editButtonTappedOnSavedSpeechTableViewCell(self, withIndexPath: indexPath)
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

/*
    SSSavedSpeechTableViewCellDelegate
*/

protocol SSSavedSpeechTableViewCellDelegate {
    
    /// Delegate method, called when the user taps the Play button.
    
    func playButtonTappedOnSavedSpeechTableViewCell(savedSpeechTableViewCell: SSSavedSpeechTableViewCell!, withIndexPath indexPath:  NSIndexPath!)
    
    /// Delegate method, called when the user taps the Edit button.
    
    func editButtonTappedOnSavedSpeechTableViewCell(savedSpeechTableViewCell: SSSavedSpeechTableViewCell!, withIndexPath indexPath:  NSIndexPath!)
    
}
