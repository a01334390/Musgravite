//
//  FloorInterfaceController.swift
//  WMusgravite Extension
//
//  Created by Fernando Martin Garcia Del Angel on 11/18/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import WatchKit
import Foundation

class FloorInterfaceController: WKInterfaceController {

    @IBOutlet weak var tableView: WKInterfaceTable!
    var rFloors:[FloorData] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        loadFloorData()
        setupTable()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "LabInterfaceController", context: rFloors[rowIndex].cod)
    }
    
    func loadFloorData(){
        let path = Bundle.main.path(forResource: "floor", ofType: "json")
        if let path = path {
            let data = NSData(contentsOfFile: path)
            if let data = data {
                let floorData = try! JSON(data:data as Data)
                let floors = floorData.array
                if let floors = floors {
                    for f in floors {
                        let model = FloorData(name: f["name"].stringValue, description: f["description"].stringValue, cod: f["cod"].intValue)
                        self.rFloors.append(model)
                    }
                }
            }
        }
    }
    
    func setupTable() {
        tableView.setNumberOfRows(rFloors.count, withRowType: "FloorRow")
        for(index, rowModel) in rFloors.enumerated() {
            if let rowController = tableView.rowController(at: index) as? FloorRow {
                rowController.floorName.setText(rowModel.name)
            }
        }
    }
}
