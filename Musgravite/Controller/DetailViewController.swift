//
//  DetailViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {
    var labInformation:JSON?
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = labInformation!["nombre"].stringValue
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
