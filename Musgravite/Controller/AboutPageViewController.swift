//
//  AboutPageViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /* Dont allow the ViewController to appear */
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            self.navigationController?.isNavigationBarHidden = true
        }
    }

}
