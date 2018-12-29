//
//  SSSavedSpeechTableViewCell.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 12-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit

protocol SSSavedSpeechTableViewCellDelegate: class {

    func playButtonTappedOnSavedSpeechTableViewCell(_ savedSpeechTableViewCell: SSSavedSpeechTableViewCell!, withIndexPath indexPath:  IndexPath!)

    func editButtonTappedOnSavedSpeechTableViewCell(_ savedSpeechTableViewCell: SSSavedSpeechTableViewCell!, withIndexPath indexPath:  IndexPath!)

}

class SSSavedSpeechTableViewCell: UITableViewCell {

    var playButton: UIButton!
    
    var editButton: UIButton!
    
    var speechTextLabel: UILabel!
    var voiceRateLabel: UILabel!
    var voicePitchLabel: UILabel!
    var languageLabel: UILabel!
    
    weak var delegate: SSSavedSpeechTableViewCellDelegate?
    
    weak var tableView: UITableView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpUI()

    }
    
    
    init(speechObject: SSSpeechObject, reuseIdentifier: String) {
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setUpUI()
        
        populateWithSpeechObject(speechObject)
        
    }

    
    func setUpUI() {

        backgroundColor = UIColor.clear
        selectionStyle = .none
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: SSSavedSpeechTableViewCell.cellHeight())

        speechTextLabel = UILabel(frame: CGRect(x: 20.0, y: 10.0, width: contentView.frame.width - 40.0, height: 60.0))
        speechTextLabel.textColor = contrastingColor
        speechTextLabel.textAlignment = .left
        speechTextLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        speechTextLabel.numberOfLines = 4
        
        contentView.addSubview(speechTextLabel)
        
        voiceRateLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 15.0))
        voiceRateLabel.textColor = contrastingColor
        voiceRateLabel.textAlignment = .left
        voiceRateLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        
        // Call UIView positioning extension method positionBelowView() on voiceRateLabel
        voiceRateLabel.positionBelowView(speechTextLabel, xOffset: 0.0, yOffset: 10.0)
        
        contentView.addSubview(voiceRateLabel)
        
        voicePitchLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 15.0))
        voicePitchLabel.textColor = contrastingColor
        voicePitchLabel.textAlignment = .left
        voicePitchLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        
        // Call UIView positioning extension method positionBelowView() on voiceRateLabel
        voicePitchLabel.positionRightFromView(voiceRateLabel, xOffset: 20.0, yOffset: 0.0)
        
        contentView.addSubview(voicePitchLabel)
        
        languageLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: contentView.frame.width - 40.0, height: 15.0))
        languageLabel.textColor = contrastingColor
        languageLabel.textAlignment = .left
        languageLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        
        // Call UIView positioning extension method positionBelowView() on languageLabel
        languageLabel.positionBelowView(voiceRateLabel, xOffset: 0.0, yOffset: 5.0)
        
        contentView.addSubview(languageLabel)
        
        playButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 30.0))
        playButton.backgroundColor = UIColor(white: 0.10, alpha: 1.0)
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(contrastingColor, for: .normal)
        playButton.layer.borderWidth = 1.0
        playButton.layer.borderColor = contrastingColor.cgColor
        playButton.addTarget(self, action: #selector(SSSavedSpeechTableViewCell.playButtonTapped), for: .touchUpInside)
        
        // Call UIView positioning extension method positionBelowView() on playButton
        playButton.positionBelowView(languageLabel, xOffset: 0.0, yOffset: 20.0)
        
        contentView.addSubview(playButton)
        
        editButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 30.0))
        editButton.backgroundColor = UIColor(white: 0.10, alpha: 1.0)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(contrastingColor, for: .normal)
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = contrastingColor.cgColor
        editButton.addTarget(self, action: #selector(SSSavedSpeechTableViewCell.editButtonTapped), for: .touchUpInside)
        
        // Call UIView positioning extension method positionRightFromView() on editButton
        editButton.positionRightFromView(playButton, xOffset: 20.0, yOffset: 0.0)
        
        contentView.addSubview(editButton)

    }
    
    /// Populate this SSSavedSpeechTableViewCell with SSSpeechObject data
    
    func populateWithSpeechObject (_ speechObject: SSSpeechObject) {

        speechTextLabel.text = speechObject.speechString
        voiceRateLabel.text = String(format: "Rate: %.2f", speechObject.rate)
        voicePitchLabel.text = String(format: "Pitch: %.2f", speechObject.pitch)
        languageLabel.text = "Language: \(SSSpeechManager.sharedManager.languageCodesAndDisplayNames[speechObject.language]!)"

    }
    
    
    /// Return this cell's height

    class func cellHeight() -> CGFloat {
        
        return 180.0;
        
    }
    
    /// Perform action when the Play button is tapped
    
    @objc
    func playButtonTapped(_ sender: UIButton!) {

        guard let indexPath = tableView?.indexPath(for: self) else { return }

        delegate?.playButtonTappedOnSavedSpeechTableViewCell(self, withIndexPath: indexPath)
        
    }
    
    /// Perform action when the Edit button is tapped
    
    @objc
    func editButtonTapped(_ sender: UIButton!) {

        guard let indexPath = tableView?.indexPath(for: self) else { return }

        delegate?.editButtonTappedOnSavedSpeechTableViewCell(self, withIndexPath: indexPath)
        
    }

}
