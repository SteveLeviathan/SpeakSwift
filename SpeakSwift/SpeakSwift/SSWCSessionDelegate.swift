//
//  WCSessionDelegate.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 12-11-17.
//  Copyright © 2017 Appify Media. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class SSWCSessionDelegate: NSObject, WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }

    func sessionDidDeactivate(_ session: WCSession) {
        //
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("SSWCSessionDelegate didReceiveMessage message: \(message)")
        let action = "get"
        let dataType = "speeches"

        guard message[action] as? String == dataType else { return }

        let reply = [dataType: SSDataManager.sharedManager.speechObjectDictionariesArray()]
        replyHandler(reply)
    }
}
