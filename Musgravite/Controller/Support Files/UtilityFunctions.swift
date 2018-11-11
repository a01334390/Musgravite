//
//  UtilityFunctions.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import Foundation
import UIKit

class UtilityFunctions {
    let gradientImages = 20
    /*
    Returns a random UIImage from the Gradient Library
    Remarks : This should work fairly fast, but does consume more energy
    Return: UIImage with a gradient
    */
    
    func getRandomBackground() -> UIImage{
        let upper_bound = (gradientImages + 1)
        return UIImage(named: "grad\(arc4random_uniform(UInt32(upper_bound)))")!
    }
}
