//
//  NetworkSupport.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class NetworkSupport {
    /* Data download links */
    let masterLabURL = "http://martinmolina.com.mx/201813/novus2018/Musgravite/laboratorios-rech.json"
    let masterFloorURL = "http://martinmolina.com.mx/201813/novus2018/Musgravite/pisos.json"
    
    func getLabURL() -> URL {
        return URL(string: masterLabURL)!
    }
    
    func getFloorUrl() -> URL {
        return URL(string: masterFloorURL)!
    }
}
