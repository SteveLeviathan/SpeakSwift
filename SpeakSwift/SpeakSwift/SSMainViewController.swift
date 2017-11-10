//
//  SSMainViewController.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 07-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit
import AVFoundation

class SSMainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, AVSpeechSynthesizerDelegate {
    
    var scrollView: UIScrollView? = nil
    var speechTextView: UITextView? = nil
    var speakButton: UIButton? = nil
    var voiceRateLabel: UILabel? = nil
    var voiceRateValueLabel: UILabel? = nil
    var voiceRateSlider: UISlider? = nil
    var voicePitchSlider: UISlider? = nil
    var voicePitchLabel: UILabel? = nil
    var voicePitchValueLabel: UILabel? = nil
    var pickerView : UIPickerView? = nil
    
    var addToFavouritesButton: UIButton? = nil
    
    let introText: String = "This is the SpeakSwift app! By pressing the 'Speak!' button, your device will speak out loud any text you've typed inside this text box!"
    
    var savedSpeechObjectsTableViewController: SSSavedSpeechObjectsTableViewController? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Custom initialization
        
        print("SSMainViewController init(nibName:bundle:)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        
        title = "SpeakSwift"
        
        // Set up the user interface
        
        setUpUI()
        
        
        // Init the SSSavedSpeechObjectsTableViewController
        
        savedSpeechObjectsTableViewController = SSSavedSpeechObjectsTableViewController(style: UITableViewStyle.plain)
        
        
    }
    
    
    func setUpUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(SSMainViewController.favouritesButtonTapped(_:)))
        
        let infoButton: UIButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(SSMainViewController.infoButtonTapped(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        // Use a UIScrollView as the container view in case we need to be able to scroll the view because of the amount of UI elements taking up more space than self.view's height
        scrollView = UIScrollView(frame: view.frame)
        
        view.addSubview(scrollView!)
        
        speechTextView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 100.0))
        speechTextView!.frame = speechTextView!.frame.insetBy(dx: 10.0, dy: 10.0)
        speechTextView!.delegate = self
        speechTextView!.text = introText
        speechTextView!.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        speechTextView!.textColor = contrastingColor
        speechTextView!.font = UIFont(name: "Helvetica Neue", size: 14.0)
        speechTextView!.returnKeyType = .done
        
        scrollView?.addSubview(speechTextView!)
        
        speakButton = UIButton(frame: CGRect(x: 0.0, y: 0.0 , width: 150.0, height: 40.0))
        speakButton?.setTitle("Speak!", for: UIControlState())
        speakButton?.setTitleColor(contrastingColor, for: UIControlState())
        speakButton?.addTarget(self, action: #selector(SSMainViewController.speakText), for: .touchUpInside)
        speakButton!.backgroundColor = UIColor(white: 0.10, alpha: 1.0)//UIColor.blackColor()
        speakButton!.layer.borderWidth = 1.0
        speakButton!.layer.borderColor = contrastingColor.cgColor
        
        // Call UIView positioning extension method positionBelowView() on speakButton
        speakButton!.positionBelowView(speechTextView!, xOffset: speechTextView!.frame.midX - speakButton!.frame.width/2.0 - 10.0, yOffset: 10.0)
        
        scrollView?.addSubview(speakButton!)
        
        addToFavouritesButton = UIButton(type: .contactAdd)
        addToFavouritesButton!.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        addToFavouritesButton!.tintColor = contrastingColor
        addToFavouritesButton?.addTarget(self, action: #selector(SSMainViewController.addToFavourites), for: .touchUpInside)
        
        // Call UIView positioning extension method positionBelowView() on addToFavouritesButton
        addToFavouritesButton?.positionBelowView(speechTextView!, absoluteX: view.frame.width - addToFavouritesButton!.frame.width - 5.0, yOffset: 10.0)
        
        scrollView?.addSubview(addToFavouritesButton!)
        
        voiceRateLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
        voiceRateLabel!.text = "Voice rate:"
        voiceRateLabel!.font = UIFont(name: "Helvetica Neue", size: 18.0)
        voiceRateLabel!.textColor = contrastingColor
        
        // Call UIView positioning extension method positionBelowView() on voiceRateLabel
        voiceRateLabel!.positionBelowView(speakButton!, absoluteX: 10.0, yOffset: 18.0)
        
        scrollView?.addSubview(voiceRateLabel!)
        
        voiceRateSlider = UISlider(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width - voiceRateLabel!.frame.width - 50.0, height: 20.0))
        voiceRateSlider!.minimumValue = 0.0
        voiceRateSlider!.maximumValue = 1.0
        voiceRateSlider!.value = 0.2
        voiceRateSlider!.minimumTrackTintColor = contrastingColor
        voiceRateSlider!.maximumTrackTintColor = contrastingColor
        voiceRateSlider!.thumbTintColor = contrastingColor
        voiceRateSlider?.addTarget(self, action: #selector(SSMainViewController.voiceRateSliderValueChanged(_:)), for: .valueChanged)
        
        // Call UIView positioning extension method positionRightFromView() on voiceRateSlider
        voiceRateSlider?.positionRightFromView(voiceRateLabel!, xOffset: 0.0, absoluteY: speakButton!.frame.maxY + 20.0)
        
        scrollView?.addSubview(voiceRateSlider!)
        
        voiceRateValueLabel = UILabel(frame: CGRect(x:0.0, y: 0.0, width: 40.0, height: 20.0))
        voiceRateValueLabel!.font = UIFont(name: "Helvetica Neue", size: 12.0)
        voiceRateValueLabel!.textColor = contrastingColor
        voiceRateSliderValueChanged(voiceRateSlider)
        
        // Call UIView positioning extension method positionRightFromView() on voiceRateValueLabel
        voiceRateValueLabel?.positionRightFromView(voiceRateSlider!, xOffset: 5.0, absoluteY: speakButton!.frame.maxY + 20.0)
        
        scrollView?.addSubview(voiceRateValueLabel!)
        
        voicePitchLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 20.0))
        voicePitchLabel!.text = "Voice pitch:"
        voicePitchLabel!.font = UIFont(name: "Helvetica Neue", size: 18.0)
        voicePitchLabel!.textColor = contrastingColor
        
        // Call UIView positioning extension method positionBelowView() on voicePitchLabel
        voicePitchLabel?.positionBelowView(voiceRateSlider!, absoluteX: 10.0, yOffset: 28.0)
        
        scrollView?.addSubview(voicePitchLabel!)
        
        voicePitchSlider = UISlider(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width - voicePitchLabel!.frame.width - 50.0, height: 20.0))
        voicePitchSlider!.minimumValue = 0.5
        voicePitchSlider!.maximumValue = 2.0
        voicePitchSlider!.value = 1.0
        voicePitchSlider!.minimumTrackTintColor = contrastingColor
        voicePitchSlider!.maximumTrackTintColor = contrastingColor
        voicePitchSlider!.thumbTintColor = contrastingColor
        voicePitchSlider?.addTarget(self, action: #selector(SSMainViewController.voicePitchSliderValueChanged(_:)), for: .valueChanged)
        
        // Call UIView positioning extension method positionRightFromView() on voicePitchSlider
        voicePitchSlider?.positionRightFromView(voicePitchLabel!, xOffset: 0.0, absoluteY: voiceRateSlider!.frame.maxY + 30.0)
        
        scrollView?.addSubview(voicePitchSlider!)
        
        voicePitchValueLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 20.0))
        voicePitchValueLabel!.font = UIFont(name: "Helvetica Neue", size: 12.0)
        voicePitchValueLabel!.textColor = contrastingColor
        voicePitchSliderValueChanged(voicePitchSlider)
        
        // Call UIView positioning extension method positionRightFromView() on voicePitchValueLabel
        voicePitchValueLabel?.positionRightFromView(voicePitchSlider!, xOffset: 5.0, absoluteY: voiceRateSlider!.frame.maxY + 30.0)
        
        scrollView?.addSubview(voicePitchValueLabel!)
        
        pickerView = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 200.0))
        pickerView!.delegate = self
        
        // Call UIView positioning extension method positionBelowView() on pickerView
        pickerView?.positionBelowView(voicePitchSlider!, absoluteX: 0.0, yOffset: 10.0)
        
        /*
        // Set the pickerView to the language of the device
        if let currentLanguageCode : String = AVSpeechSynthesisVoice.currentLanguageCode() {
            let index: Int = SSSpeechManager.sharedManager.languageCodes.bridgeToObjectiveC().indexOfObject(currentLanguageCode)
            if index != NSNotFound {
                pickerView?.selectRow(index, inComponent: 0, animated: false)
            }
            
        }
        */
        
        // Set the pickerView to en-US (English (United States))
        let index: Int = (SSSpeechManager.sharedManager.languageCodes as NSArray).index(of: "en-US")
        if index != NSNotFound {
            pickerView?.selectRow(index, inComponent: 0, animated: false)
        }
        
        scrollView?.addSubview(pickerView!)
        
    }
    
    func infoButtonTapped(_ sender: UIButton!) {
        
        let title = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let message = "\nVersion: \(version) (build: \(build))\n\nAppify Media\n\nAppifyMedia.com"
        let btnTitle = "OK"
        
        // in iOS 8.0, UIAlertView/UIActionSheet is deprecated and replaced by UIAlertController
        
        //var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.Default, handler: nil))
        //self.presentViewController(alert, animated: true, completion: nil)
        
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: btnTitle)
        alert.show()
        
    }
    
    
    func updateUIControlsWithSpeechObject(_ speechObject : SSSpeechObject?) {
        
        if let speechObj = speechObject {
            
            speechTextView!.text = speechObj.speechString
            
            let pickerViewIndex = (SSSpeechManager.sharedManager.languageCodes as NSArray).index(of: speechObj.language)
            pickerView?.selectRow(pickerViewIndex, inComponent: 0, animated: true)
            
            voiceRateSlider!.value = speechObj.rate
            voiceRateSliderValueChanged(voiceRateSlider!)
            
            voicePitchSlider!.value = speechObj.pitch
            voicePitchSliderValueChanged(voicePitchSlider!)
            
        }
        
    }
    
    /// Make the device speak te text.
    
    func speakText() {
        
        // Hide keyboard
        
        speechTextView!.resignFirstResponder()
        
        if !SSSpeechManager.sharedManager.speechSynthesizer.isSpeaking {
            
            
            // Check if sharedSpeechManager.languageCodesAndDisplayNames dictionary has entries, if not this means there are no speech voices available on the device. (e.g.: The iPhone Simulator)
            
            if SSSpeechManager.sharedManager.languageCodesAndDisplayNames.count > 0 {
                
                let speechObject: SSSpeechObject = SSSpeechObject.speechObjectWith(speechString: speechTextView!.text!, language: SSSpeechManager.sharedManager.languageCodes[pickerView!.selectedRow(inComponent: 0)], rate: voiceRateSlider!.value, pitch: voicePitchSlider!.value, volume: 1.0)
                
                SSSpeechManager.sharedManager.speechSynthesizer.delegate = self
                
                SSSpeechManager.sharedManager.speakWithSpeechObject(speechObject)
                
            }
            
        } else {
            
            // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
            
            SSSpeechManager.sharedManager.speechSynthesizer.stopSpeaking(at: .immediate)
            
        }
        
    }
    
    
    /// Add the speech text to your favourites
    
    func addToFavourites() {
        
        if SSSpeechManager.sharedManager.languageCodesAndDisplayNames.count > 0 {
            
            let speechObject: SSSpeechObject = SSSpeechObject.speechObjectWith(speechString: speechTextView!.text!, language: SSSpeechManager.sharedManager.languageCodes[pickerView!.selectedRow(inComponent: 0)], rate: voiceRateSlider!.value, pitch: voicePitchSlider!.value, volume: 1.0)
            
            SSDataManager.sharedManager.addSpeechObject(speechObject: speechObject)
            
            let title = "Favourites"
            let message = "The speech text was added to your favourites."
            let btnTitle = "OK"
            
            // in iOS 8.0, UIAlertView/UIActionSheet is deprecated and replaced by UIAlertController
            
            //var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            //alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.Default, handler: nil))
            //self.presentViewController(alert, animated: true, completion: nil)
            
            let alert = UIAlertView()
            alert.title = title
            alert.message = message
            alert.addButton(withTitle: btnTitle)
            alert.show()
        }
        
    }
    
    
    func voicePitchSliderValueChanged(_ sender: UISlider!) {
        
        // Format CFloat value to 2 decimal places
        
        voicePitchValueLabel!.text = String(format: "%.2f", sender!.value)
    }
    
    
    func voiceRateSliderValueChanged(_ sender: UISlider!) {
        
        // Format CFloat value to 2 decimal places
        
        voiceRateValueLabel!.text = String(format: "%.2f", sender!.value)
    }
    
    
    func favouritesButtonTapped(_ sender: UIButton!) {
        
        speechTextView!.resignFirstResponder()
        
        navigationController?.pushViewController(savedSpeechObjectsTableViewController!, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
        return UIInterfaceOrientationMask.all
    }
    
    /*
        UIPickerViewDelegate & UIPickerViewDatasource methods
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int  {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int  {
        
        // If there are no language codes, because of the app running in the iPhone Simulator, return 1, so we can display 1 title to tell the user there are no speech voices
        
        if SSSpeechManager.sharedManager.languageCodes.count == 0 {
            return 1
        }
        
        return SSSpeechManager.sharedManager.languageCodes.count
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if SSSpeechManager.sharedManager.languageCodes.count > 0 {
            
            let languageCode : String = SSSpeechManager.sharedManager.languageCodes[row]
            let languageDisplayName : String = SSSpeechManager.sharedManager.languageCodesAndDisplayNames[languageCode]!
            
            let attrString: NSAttributedString = NSAttributedString(string: languageDisplayName, attributes: [NSForegroundColorAttributeName: contrastingColor])
            
            return attrString
            
        }
        
        return NSAttributedString(string: "Simulator: No speech voices.", attributes: [NSForegroundColorAttributeName: contrastingColor])
        
    }
    
    
    /*
        UITextViewDelegate methods
    */
    
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
    
    
    // #pragma mark - AVSpeechSynthesizerDelegate methods
    /*
    // #pragma mark - Navigation
    */
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        print("SSMainViewController speechSynthesizer: didStartSpeechUtterance:")
        
        speakButton!.titleLabel?.text = "Stop!"
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        print("SSMainViewController speechSynthesizer: didFinishSpeechUtterance:")
        
        speakButton!.titleLabel?.text = "Speak!"
        
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        
        print("SSMainViewController speechSynthesizer: didCancelSpeechUtterance:")
        
        speakButton!.titleLabel?.text = "Speak!"
        
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
