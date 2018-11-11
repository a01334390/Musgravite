//
//  LabCards.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON
import SVProgressHUD

class LabCards {
    
    /*
     This function retrieves all data from Floors
     Returns : A JSON with all the information
    */
    func retrieveFloorData() -> JSON {
        let data = try? Data(contentsOf: NetworkSupport().getFloorUrl())
        if let json = try? JSON(data: data!) {
            SVProgressHUD.dismiss()
            return json
        } else {
            return JSON()
        }
    }
    
    /*
     This function retrieves all data from Laboratories
     Returns : A JSON with all the information
     */
    func retrieveLabData() -> JSON {
        let data = try? Data(contentsOf: NetworkSupport().getLabURL())
        if let json = try? JSON(data: data!) {
            SVProgressHUD.dismiss()
            return json
        } else {
            return JSON()
        }
    }
    
}
