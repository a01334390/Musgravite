//
//  WaitInterfaceController.swift
//  WMusgravite Extension
//
//  Created by Fernando Martin Garcia Del Angel on 11/18/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import WatchConnectivity
import WatchKit

class WaitInterfaceController: WKInterfaceController, WCSessionDelegate{
    
    var wcSession: WCSession!
    var l:JSON!
    
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        do {
            l = try! JSON(data: messageData)
            let model = LabData(
                nombre: l["nombre"].stringValue,
                descripcion: l["descripcion"].stringValue,
                encargado: l["encargado"].stringValue,
                ubicacion: l["ubicacion"].stringValue,
                piso: l["piso"].stringValue,
                trayectoria: l["trayectoria"].stringValue,
                posterImage: l["posterImage"].stringValue
            )
            pushController(withName: "DetailInterfaceController", context: model)
        } catch let error {
            print(error)
        }
    }

}
