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


// Where you typically used the #define directive to define a primitive constant in C and Objective-C, in Swift you use a global constant instead.
let iOSVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue

// Color constants
let honeydewColor: UIColor = UIColor(red: 204.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0) // honeydew
let skyColor: UIColor = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0) // sky
let floraColor: UIColor = UIColor(red: 102.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0) // flora
let limeColor: UIColor = UIColor(red: 128.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0) // lime
let seaFomeaColor: UIColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 128.0/255.0, alpha: 1.0) // sea foam
let orangeColor: UIColor = UIColor.orangeColor()

// Set contrasting color to be used throughout the app
let contrastingColor: UIColor = floraColor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow? = nil
    
    var rootNavigationController: SSRootNavigationController? = nil
    
    var mainViewController: SSMainViewController? = nil
    
    class func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        println("Run this app on your device! The iPhone Simulator might not have Speech Voices (AVSpeechSynthesisVoice)!")
        
        //Set up some UINavigationBar color settings
        
        UINavigationBar.appearance().tintColor = contrastingColor
        UINavigationBar.appearance().barTintColor = UIColor(white: 0.05, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: contrastingColor]
        UIPickerView.appearance().tintColor = contrastingColor
        
        
        // Set the rootNavigationController as the window's rootViewController
        
        rootNavigationController = window!.rootViewController! as? SSRootNavigationController
        
        
        // Init the SSMainViewController
        
        mainViewController = SSMainViewController()
        
        
        // Add the mainViewController to the rootNavigationController
        
        rootNavigationController?.addChildViewController(mainViewController!)
        
        
        // Load saved Speech Objects
        
        SSDataManager.sharedManager.speechObjects = SSDataManager.sharedManager.savedSpeechObjects()
        
        return true
        
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        println("applicationWillResignActive()")
        
        // Save Speech Objects to NSUserDefaults.standardUserDefaults()
        
        SSDataManager.sharedManager.saveSpeechObjects()
        
        
        // If speaking, call stopSpeakingAtBoundary: to interrupt current speech and clear the queue.
        
        if SSSpeechManager.sharedManager.speechSynthesizer.speaking {
            SSSpeechManager.sharedManager.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
        }
        
    }

    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
       
        println("applicationWillEnterForeground()")
        
    }

    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Save Speech Objects to NSUserDefaults.standardUserDefaults()
        
        SSDataManager.sharedManager.saveSpeechObjects()
        
        println("applicationWillTerminate()")
        
    }

}

