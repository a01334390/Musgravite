//
//  P360ViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/15/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import CTPanoramaView


class P360ViewController: UIViewController {
    var panonoImageURL:URL?
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
    
    private func load(fileURL: URL) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func loadSphericalImage() {
        pv.image = load(fileURL: panonoImageURL!)
    }
    
    func loadCylindricalImage() {
        pv.image = load(fileURL: panonoImageURL!)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }


}
