//
//  DetailInterfaceController.swift
//  WMusgravite Extension
//
//  Created by Fernando Martin Garcia Del Angel on 11/18/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import WatchKit
import Foundation

public extension WKInterfaceImage {
    
    public func setImageWithUrl(url:String, scale: CGFloat = 1.0) -> WKInterfaceImage? {
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            if (data != nil && error == nil) {
                let image = UIImage(data: data!, scale: scale)
                
                DispatchQueue.main.async() {
                    self.setImage(image)
                }
            } else if error != nil {
                print(error)
            }
            }.resume()
        
        return self
    }
}

class DetailInterfaceController: WKInterfaceController {
/* Variables */
    @IBOutlet weak var bigtitleOutlet: WKInterfaceLabel!
    @IBOutlet weak var bigImageOutlet: WKInterfaceImage!
    @IBOutlet weak var labLocationOutlet: WKInterfaceLabel!
    @IBOutlet weak var floorLocationOutlet: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        if let receivedLab = context as? LabData {
            setupStaticElements(receivedLab)
        }
    }
    
    func setupStaticElements(_ lab:LabData){
        bigtitleOutlet.setText(lab.nombre)
        labLocationOutlet.setText(lab.ubicacion)
        floorLocationOutlet.setText(lab.piso)
        bigImageOutlet.setImageWithUrl(url: lab.posterImage)
    }
    
    @IBAction func onMenuBackTap() {
        presentController(withName: "InterfaceController", context: nil)
    }
}
