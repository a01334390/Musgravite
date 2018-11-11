//
//  CustomNavViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit

class CustomNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        stylizeNavBar()
    }
    
    /*
    Makes the navigation bar transparent (removing color and stripes)
     - Remarks: This has to be added manually to each bar
    */
    func stylizeNavBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
