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
    let masterLabURL = "https://s3.amazonaws.com/purple-cdtc/laboratorios-rech.json"
    let masterFloorURL = "https://s3.amazonaws.com/purple-cdtc/labs.json"
    /* Information data */
    var floorData:Data?
    var labData:Data?
    
    func initialDownload() -> Bool {
        /* Convert to URL */
        let lUrl = URL(string: masterLabURL)
        let fURL = URL(string: masterFloorURL)
        /* Convert to data */
        floorData = try? Data(contentsOf: lUrl!)
        labData = try? Data(contentsOf: fURL!)
        return true
    }
    
}
