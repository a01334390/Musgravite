//
//  PermissionsManager.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/3/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class PermissionsManager {
    static let shared = PermissionsManager()
    
    let locationManager = CLLocationManager()
    
    func requestLocalNotifications() {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    func requestWhenInUseLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}
