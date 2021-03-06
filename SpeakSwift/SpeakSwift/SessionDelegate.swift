//
//  SessionDelegate.swift
//  SpeakSwift
//
//  Created by Steve Overmars on 12-11-17.
//  Copyright © 2017 Appify Media. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class SessionDelegate: NSObject, WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {}

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let actionGet = "get"
        let dataTypeSpeeches = "speeches"

        guard message[actionGet] as? String == dataTypeSpeeches else { return }

        let reply = [dataTypeSpeeches: DataManager.shared.speechObjectDictionariesArray()]
        replyHandler(reply)
    }
}
