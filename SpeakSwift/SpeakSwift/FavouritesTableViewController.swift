//
//  FavouritesTableViewController.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 09-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit
import AVFoundation
import Crashlytics

class FavouritesTableViewController: UITableViewController {

    weak var mainViewControllerDelegate: MainViewControllerDelegate?

    let speechManager = SpeechManager.shared

    let dataManager = DataManager.shared

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

}

extension FavouritesTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.speechObjects.count
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavouriteTableViewCell.cellHeight()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifer = "FavouriteTableViewCellIdentifier"
        let cell: FavouriteTableViewCell

        if !dataManager.speechObjects.isEmpty {

            let speechObject = dataManager.speechObjects[indexPath.row]

            let language = speechManager.languageCodesAndDisplayNames[speechObject.language]!

            cell = FavouriteTableViewCell(speechObject: speechObject, language: language, reuseIdentifier: cellIdentifer)


        } else {

            cell = FavouriteTableViewCell(style: .default, reuseIdentifier: cellIdentifer)

        }

        // Set the delegate to self so it responds to FavouriteTableViewCellDelegate methods
        cell.delegate = self

        cell.tableView = tableView

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            dataManager.speechObjects.remove(at: indexPath.row)

            dataManager.saveSpeechObjects()

            tableView.deleteRows(at: [indexPath], with: .fade)

        }

    }

}

// MARK: - AVSpeechSynthesizerDelegate methods

extension FavouritesTableViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {

        mainViewControllerDelegate?.setSpeakButtonTitle(title: "Stop!")

    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {

        mainViewControllerDelegate?.setSpeakButtonTitle(title: "Speak!")

    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {

        mainViewControllerDelegate?.setSpeakButtonTitle(title: "Speak!")

    }

}

// MARK: - FavouriteTableViewCellDelegate methods

extension FavouritesTableViewController: FavouriteTableViewCellDelegate {

    func playButtonTappedOnFavouriteTableViewCell(_ FavouriteTableViewCell: FavouriteTableViewCell!, withIndexPath indexPath: IndexPath!) {

        if speechManager.speechSynthesizer.isSpeaking {
            // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
            speechManager.speechSynthesizer.stopSpeaking(at: .immediate)
        }

        if !speechManager.languageCodesAndDisplayNames.isEmpty {

            let speechObject = dataManager.speechObjects[indexPath.row]

            speechManager.speechSynthesizer.delegate = self

            speechManager.speakWithSpeechObject(speechObject)

            Answers.logCustomEvent(
                withName: "speakWithSpeechObject",
                customAttributes: [
                    "language": speechObject.language,
                    "rate":speechObject.rate,
                    "pitch": speechObject.pitch,
                    "text": speechObject.speechString,
                    "view": "Favourites"
                ]
            )

        }

    }

    func editButtonTappedOnFavouriteTableViewCell(_ FavouriteTableViewCell: FavouriteTableViewCell!, withIndexPath indexPath: IndexPath!) {

        self.navigationController?.popViewController(animated: true)

        let speechObject = dataManager.speechObjects[indexPath.row]

        mainViewControllerDelegate?.updateUIControlsWithSpeechObject(speechObject)

    }

}
