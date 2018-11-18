//
//  InterfaceController.swift
//  WMusgravite Extension
//
//  Created by Fernando Martin Garcia Del Angel on 11/16/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    /* UI Elements */
    @IBOutlet weak var avatarImageOutlet: WKInterfaceImage!
    @IBOutlet weak var nameOutlet: WKInterfaceLabel!
    var wcSession: WCSession!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        nameOutlet.setText(message["message"] as? String)
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        avatarImageOutlet.setImage(UIImage(data: messageData))
    }

}
