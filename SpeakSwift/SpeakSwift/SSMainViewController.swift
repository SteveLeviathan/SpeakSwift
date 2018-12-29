//
//  SSMainViewController.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 07-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit
import AVFoundation

protocol SSMainViewControllerDelegate: class {
    func setSpeakButtonTitle(title: String)
    func updateUIControlsWithSpeechObject(_ speechObject: SSSpeechObject)
}

class SSMainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, AVSpeechSynthesizerDelegate {
    
    var scrollView: UIScrollView!
    var speechTextView: UITextView!
    var speakButton: UIButton!
    var voiceRateLabel: UILabel!
    var voiceRateValueLabel: UILabel!
    var voiceRateSlider: UISlider!
    var voicePitchSlider: UISlider!
    var voicePitchLabel: UILabel!
    var voicePitchValueLabel: UILabel!
    var pickerView: UIPickerView!
    
    var addToFavouritesButton: UIButton!
    
    let introText  = "This is the SpeakSwift app! By pressing the 'Speak!' button, your device will speak out loud any text you've typed inside this text box!"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        
        title = "SpeakSwift"
        
        // Set up the user interface
        
        setUpUI()

    }
    
    
    func setUpUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(favouritesButtonTapped))
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        // Use a UIScrollView as the container view in case we need to be able to scroll the view because of the amount of UI elements taking up more space than self.view's height
        scrollView = UIScrollView(frame: view.frame)
        
        view.addSubview(scrollView)
        
        speechTextView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 100.0))
        speechTextView.frame = speechTextView.frame.insetBy(dx: 10.0, dy: 10.0)
        speechTextView.delegate = self
        speechTextView.text = introText
        speechTextView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        speechTextView.textColor = contrastingColor
        speechTextView.font = UIFont(name: "Helvetica Neue", size: 14.0)
        speechTextView.returnKeyType = .done
        
        scrollView.addSubview(speechTextView!)
        
        speakButton = UIButton(frame: CGRect(x: 0.0, y: 0.0 , width: 150.0, height: 40.0))
        speakButton.setTitle("Speak!", for: .normal)
        speakButton.setTitleColor(contrastingColor, for: .normal)
        speakButton.addTarget(self, action: #selector(speakText), for: .touchUpInside)
        speakButton.backgroundColor = UIColor(white: 0.10, alpha: 1.0)
        speakButton.layer.borderWidth = 1.0
        speakButton.layer.borderColor = contrastingColor.cgColor
        
        // Call UIView positioning extension method positionBelowView() on speakButton
        speakButton.positionBelowView(speechTextView, xOffset: speechTextView.frame.midX - speakButton.frame.width / 2.0 - 10.0, yOffset: 10.0)
        
        scrollView.addSubview(speakButton)
        
        addToFavouritesButton = UIButton(type: .contactAdd)
        addToFavouritesButton.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        addToFavouritesButton.tintColor = contrastingColor
        addToFavouritesButton.addTarget(self, action: #selector(addToFavourites), for: .touchUpInside)
        
        // Call UIView positioning extension method positionBelowView() on addToFavouritesButton
        addToFavouritesButton.positionBelowView(speechTextView, absoluteX: view.frame.width - addToFavouritesButton.frame.width - 5.0, yOffset: 10.0)
        
        scrollView.addSubview(addToFavouritesButton)
        
        voiceRateLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
        voiceRateLabel.text = "Voice rate:"
        voiceRateLabel.font = UIFont(name: "Helvetica Neue", size: 18.0)
        voiceRateLabel.textColor = contrastingColor
        
        // Call UIView positioning extension method positionBelowView() on voiceRateLabel
        voiceRateLabel.positionBelowView(speakButton, absoluteX: 10.0, yOffset: 18.0)
        
        scrollView.addSubview(voiceRateLabel)
        
        voiceRateSlider = UISlider(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width - voiceRateLabel.frame.width - 50.0, height: 20.0))
        voiceRateSlider.minimumValue = 0.0
        voiceRateSlider.maximumValue = 1.0
        voiceRateSlider.value = 0.52
        voiceRateSlider.minimumTrackTintColor = contrastingColor
        voiceRateSlider.maximumTrackTintColor = contrastingColor
        voiceRateSlider.thumbTintColor = contrastingColor
        voiceRateSlider.addTarget(self, action: #selector(voiceRateSliderValueChanged), for: .valueChanged)
        
        // Call UIView positioning extension method positionRightFromView() on voiceRateSlider
        voiceRateSlider.positionRightFromView(voiceRateLabel, xOffset: 0.0, absoluteY: speakButton.frame.maxY + 20.0)
        
        scrollView.addSubview(voiceRateSlider)
        
        voiceRateValueLabel = UILabel(frame: CGRect(x:0.0, y: 0.0, width: 40.0, height: 20.0))
        voiceRateValueLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        voiceRateValueLabel.textColor = contrastingColor
        voiceRateSliderValueChanged(voiceRateSlider)
        
        // Call UIView positioning extension method positionRightFromView() on voiceRateValueLabel
        voiceRateValueLabel.positionRightFromView(voiceRateSlider, xOffset: 5.0, absoluteY: speakButton.frame.maxY + 20.0)
        
        scrollView.addSubview(voiceRateValueLabel)
        
        voicePitchLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
        voicePitchLabel.text = "Voice pitch:"
        voicePitchLabel.font = UIFont(name: "Helvetica Neue", size: 18.0)
        voicePitchLabel.textColor = contrastingColor
        
        // Call UIView positioning extension method positionBelowView() on voicePitchLabel
        voicePitchLabel.positionBelowView(voiceRateSlider, absoluteX: 10.0, yOffset: 28.0)
        
        scrollView.addSubview(voicePitchLabel)
        
        voicePitchSlider = UISlider(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width - voicePitchLabel.frame.width - 50.0, height: 20.0))
        voicePitchSlider.minimumValue = 0.5
        voicePitchSlider.maximumValue = 2.0
        voicePitchSlider.value = 1.0
        voicePitchSlider.minimumTrackTintColor = contrastingColor
        voicePitchSlider.maximumTrackTintColor = contrastingColor
        voicePitchSlider.thumbTintColor = contrastingColor
        voicePitchSlider.addTarget(self, action: #selector(voicePitchSliderValueChanged), for: .valueChanged)
        
        // Call UIView positioning extension method positionRightFromView() on voicePitchSlider
        voicePitchSlider.positionRightFromView(voicePitchLabel, xOffset: 0.0, absoluteY: voiceRateSlider.frame.maxY + 30.0)
        
        scrollView.addSubview(voicePitchSlider)
        
        voicePitchValueLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 20.0))
        voicePitchValueLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        voicePitchValueLabel.textColor = contrastingColor
        voicePitchSliderValueChanged(voicePitchSlider)
        
        // Call UIView positioning extension method positionRightFromView() on voicePitchValueLabel
        voicePitchValueLabel.positionRightFromView(voicePitchSlider, xOffset: 5.0, absoluteY: voiceRateSlider.frame.maxY + 30.0)
        
        scrollView.addSubview(voicePitchValueLabel)
        
        pickerView = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 200.0))
        pickerView.delegate = self
        
        // Call UIView positioning extension method positionBelowView() on pickerView
        pickerView.positionBelowView(voicePitchSlider, absoluteX: 0.0, yOffset: 10.0)
        
        /*
        // Set the pickerView to the language of the device
        if let currentLanguageCode = AVSpeechSynthesisVoice.currentLanguageCode() {
            let index = SSSpeechManager.sharedManager.languageCodes.bridgeToObjectiveC().indexOfObject(currentLanguageCode)
            if index != NSNotFound {
                pickerView?.selectRow(index, inComponent: 0, animated: false)
            }
            
        }
        */
        
        // Set the pickerView to en-US (English (United States))
        let index = (SSSpeechManager.sharedManager.languageCodes as NSArray).index(of: "en-US")
        if index != NSNotFound {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        scrollView.addSubview(pickerView)
        
    }
    
    @objc
    func infoButtonTapped(_ sender: UIButton!) {
        
        let title = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let message = "\nVersion: \(version) (build: \(build))\n\nAppify Media\n\nAppifyMedia.com"
        let btnTitle = "OK"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: btnTitle, style: .default))
        present(alertController, animated: true)

    }
    
    /// Make the device speak te text.
    
    @objc
    func speakText() {
        
        // Hide keyboard
        
        speechTextView.resignFirstResponder()
        
        if !SSSpeechManager.sharedManager.speechSynthesizer.isSpeaking {
            
            
            // Check if sharedSpeechManager.languageCodesAndDisplayNames dictionary has entries, if not this means there are no speech voices available on the device. (e.g.: The iPhone Simulator)
            
            if !SSSpeechManager.sharedManager.languageCodesAndDisplayNames.isEmpty {
                
                let speechObject = SSSpeechObject.speechObjectWith(
                    speechString: speechTextView.text!,
                    language: SSSpeechManager.sharedManager.languageCodes[pickerView.selectedRow(inComponent: 0)],
                    rate: voiceRateSlider.value,
                    pitch: voicePitchSlider.value,
                    volume: 1.0
                )
                
                SSSpeechManager.sharedManager.speechSynthesizer.delegate = self
                
                SSSpeechManager.sharedManager.speakWithSpeechObject(speechObject)
                
            }
            
        } else {
            
            // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
            
            SSSpeechManager.sharedManager.speechSynthesizer.stopSpeaking(at: .immediate)
            
        }
        
    }
    
    
    /// Add the speech text to your favourites
    
    @objc
    func addToFavourites() {
        
        if !SSSpeechManager.sharedManager.languageCodesAndDisplayNames.isEmpty {
            
            let speechObject = SSSpeechObject.speechObjectWith(
                speechString: speechTextView.text!,
                language: SSSpeechManager.sharedManager.languageCodes[pickerView.selectedRow(inComponent: 0)],
                rate: voiceRateSlider.value,
                pitch: voicePitchSlider.value,
                volume: 1.0
            )
            
            SSDataManager.sharedManager.addSpeechObject(speechObject: speechObject)
            
            let title = "Favourites"
            let message = "The speech text was added to your favourites."
            let btnTitle = "OK"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: btnTitle, style: .default))
            present(alertController, animated: true)

        }
        
    }
    
    
    @objc
    func voicePitchSliderValueChanged(_ sender: UISlider) {
        
        // Format Float value to 2 decimal places
        
        voicePitchValueLabel.text = String(format: "%.2f", sender.value)
    }
    
    
    @objc
    func voiceRateSliderValueChanged(_ sender: UISlider) {
        
        // Format Float value to 2 decimal places
        
        voiceRateValueLabel.text = String(format: "%.2f", sender.value)
    }
    
    
    @objc
    func favouritesButtonTapped(_ sender: UIButton) {
        
        speechTextView.resignFirstResponder()

        let savedSpeechObjectsTableViewController = SSSavedSpeechObjectsTableViewController(style: .plain)
        savedSpeechObjectsTableViewController.mainViewControllerDelegate = self
        navigationController?.pushViewController(savedSpeechObjectsTableViewController, animated: true)
        
    }

    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask  {
        return UIInterfaceOrientationMask.all
    }

    // MARK: - UIPickerViewDelegate & UIPickerViewDatasource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int  {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int  {
        
        // If there are no language codes, because of the app running in the iPhone Simulator, return 1, so we can display 1 title to tell the user there are no speech voices

        let count = SSSpeechManager.sharedManager.languageCodes.count

        if count == 0 {
            return 1
        }
        
        return count
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if !SSSpeechManager.sharedManager.languageCodes.isEmpty {
            
            let languageCode = SSSpeechManager.sharedManager.languageCodes[row]
            let languageDisplayName = SSSpeechManager.sharedManager.languageCodesAndDisplayNames[languageCode]!
            
            let attrString = NSAttributedString(string: languageDisplayName, attributes: [.foregroundColor: contrastingColor])
            
            return attrString
            
        }
        
        return NSAttributedString(string: "No speech voices.", attributes: [.foregroundColor: contrastingColor])
        
    }

    // MARK: - UITextViewDelegate methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        // Clear intro text
        
        if textView.text == introText {
            textView.text = ""
        }
        
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    
    // MARK: - AVSpeechSynthesizerDelegate methods

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        speakButton.titleLabel?.text = "Stop!"
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        speakButton.titleLabel?.text = "Speak!"

    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        
        speakButton.titleLabel?.text = "Speak!"
        
    }

}


extension SSMainViewController: SSMainViewControllerDelegate {
    func setSpeakButtonTitle(title: String) {
        speakButton.setTitle(title, for: .normal)
    }

    func updateUIControlsWithSpeechObject(_ speechObject: SSSpeechObject) {

        speechTextView.text = speechObject.speechString

        let pickerViewIndex = (SSSpeechManager.sharedManager.languageCodes as NSArray).index(of: speechObject.language)
        pickerView.selectRow(pickerViewIndex, inComponent: 0, animated: true)

        voiceRateSlider.value = speechObject.rate
        voiceRateSliderValueChanged(voiceRateSlider)

        voicePitchSlider.value = speechObject.pitch
        voicePitchSliderValueChanged(voicePitchSlider)

    }
}
