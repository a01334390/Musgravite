//
//  P360ViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/15/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import SceneKit
import CTPanoramaView
import SwiftMessages

class P360ViewController: UIViewController {
    var panonoImage:UIImage?
    @IBOutlet weak var compassView: CTPieSliceView!
    @IBOutlet weak var pv: CTPanoramaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSphericalImage()
        pv.compass = compassView
    }
    
    @IBAction func panoramaTypeTapped() {
        if pv.panoramaType == .spherical {
            loadCylindricalImage()
        }
        else {
            loadSphericalImage()
        }
    }
    
    @IBAction func motionTypeTapped() {
        if pv.controlMethod == .touch {
            pv.controlMethod = .motion
        }
        else {
            pv.controlMethod = .touch
        }
    }
    
    func loadSphericalImage() {
        pv.image = panonoImage
    }
    
    func loadCylindricalImage() {
        pv.image = panonoImage
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}
