//
//  ExtensionDelegate.swift
//  SpeakSwift WatchKit Extension
//
//  Created by Steve Overmars on 11-11-17.
//  Copyright © 2017 Appify Media. All rights reserved.
//

import WatchKit
import WatchConnectivity

protocol WCSessionDelegateListening {
    func receivedData(_ data: [String: Any])
}

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    var listeners: [WCSessionDelegateListening] = []

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

        fetchData()

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        notifyListenersWith(data: message)
        let reply = ["status": "OK"]
        replyHandler(reply)
    }

    func fetchData() {
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        guard session.isReachable else { return }

        session.sendMessage(["get": "speeches"], replyHandler: { (reply) in
            self.notifyListenersWith(data: reply)
        }) { (error) in
            //
        }
    }

    func subscribe(listener: WCSessionDelegateListening) {
        listeners.append(listener)
    }

    func notifyListenersWith(data: [String: Any]) {
        listeners.forEach {
            $0.receivedData(data)
        }
    }


    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    @available(watchOSApplicationExtension 3.0, *)
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    backgroundTask.setTaskCompletedWithSnapshot(false)
                } else {
                    // Fallback on earlier versions
                }
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    connectivityTask.setTaskCompletedWithSnapshot(false)
                } else {
                    // Fallback on earlier versions
                }
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    urlSessionTask.setTaskCompletedWithSnapshot(false)
                } else {
                    // Fallback on earlier versions
                }
            default:
                // make sure to complete unhandled task types
                if #available(watchOSApplicationExtension 4.0, *) {
                    task.setTaskCompletedWithSnapshot(false)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }

}
