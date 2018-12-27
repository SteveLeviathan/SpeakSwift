//    The MIT License (MIT)
//
//    Copyright (c) 2014 Appify Media, Steve Overmars
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


//
//  AppDelegate.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 07-06-14.
//  Copyright (c) 2014 Appify Media. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow? = nil
    
    var rootNavigationController: SSRootNavigationController!
    
    var mainViewController: SSMainViewController!

    var wcSessionDelegate: SSWCSessionDelegate!
    
    class func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("Run this app on your device! The iPhone Simulator might not have Speech Voices (AVSpeechSynthesisVoice)!")
        
        //Set up some UI color settings
        
        setupUIAppearance()
        
        
        // Set the rootNavigationController as the window's rootViewController
        
        rootNavigationController = window!.rootViewController! as? SSRootNavigationController
        
        
        // Init the SSMainViewController
        
        mainViewController = SSMainViewController()
        
        
        // Add the mainViewController to the rootNavigationController
        
        rootNavigationController?.addChild(mainViewController!)
        
        
        // Load saved Speech Objects
        
        SSDataManager.sharedManager.speechObjects = SSDataManager.sharedManager.savedSpeechObjects()
        
        // Crashlytics
        Fabric.with([Crashlytics()])


        activateWatchConnectivitySession()


        return true
        
    }

    private func setupUIAppearance() {
        UINavigationBar.appearance().tintColor = contrastingColor
        UINavigationBar.appearance().barTintColor = UIColor(white: 0.05, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: contrastingColor]
        UIPickerView.appearance().tintColor = contrastingColor
    }

    private func activateWatchConnectivitySession() {
        if (WCSession.isSupported()) {
            let session = WCSession.default
            wcSessionDelegate = SSWCSessionDelegate()
            session.delegate = wcSessionDelegate
            session.activate()

            if session.isPaired != true {
                print("Apple Watch is not paired")
            }

            if session.isWatchAppInstalled != true {
                print("WatchKit app is not installed")
            }
        } else {
            print("WatchConnectivity is not supported on this device")
        }
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        print("applicationWillResignActive()")
        
        // Save Speech Objects to NSUserDefaults.standardUserDefaults()
        
        SSDataManager.sharedManager.saveSpeechObjects()
        
        
        // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
        
        if SSSpeechManager.sharedManager.speechSynthesizer.isSpeaking {
            SSSpeechManager.sharedManager.speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
       
        print("applicationWillEnterForeground()")
        
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Answers.logCustomEvent(withName: "SpeakSwift applicationDidBecomeActive", customAttributes: nil)
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Save Speech Objects to NSUserDefaults.standardUserDefaults()
        
        SSDataManager.sharedManager.saveSpeechObjects()
        
        print("applicationWillTerminate()")
        
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
