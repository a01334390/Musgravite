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
    
    /* UI Elements */
    @IBOutlet weak var nameOutlet: WKInterfaceLabel!
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        WKInterfaceDevice().play(.notification)
        var json:JSON?
        do{
            json = try! JSON(data: messageData)
        }
        print(json!)
    }

}
