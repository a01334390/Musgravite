//
//  LabInterfaceController.swift
//  WMusgravite Extension
//
//  Created by Fernando Martin Garcia Del Angel on 11/18/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import WatchKit


class LabInterfaceController: WKInterfaceController {
    var rLabs:[LabData] = []
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let receivedFloor = context as? Int {
            loadLabData(receivedFloor)
            setupTable()
        }
    }
    
    func setupTable(){
        tableView.setNumberOfRows(rLabs.count, withRowType: "LabRow")
        for(index, rowModel) in rLabs.enumerated() {
            if let rowController = tableView.rowController(at: index) as? LabRow {
                rowController.labName.setText(rowModel.nombre)
            }
        }
    }
    
    func loadLabData(_ receivedFloor:Int) {
        let path = Bundle.main.path(forResource: "lab", ofType: "json")
        if let path = path {
            let data = NSData(contentsOfFile: path)
            if let data = data {
                let labData = try! JSON(data:data as Data)
                let labs = labData.array
                if let labs = labs {
                    for l in labs {
                        if Int(l["piso"].stringValue) == receivedFloor {
                            let model = LabData(
                                nombre: l["nombre"].stringValue,
                                descripcion: l["descripcion"].stringValue,
                                encargado: l["encargado"].stringValue,
                                ubicacion: l["ubicacion"].stringValue,
                                piso: l["piso"].stringValue,
                                trayectoria: l["trayectoria"].stringValue,
                                posterImage: l["posterImage"].stringValue,
                                x : l["coordinates"].arrayValue[0].doubleValue,
                                y : l["coordinates"].arrayValue[1].doubleValue
                            )
                            self.rLabs.append(model)
                        }
                    }
                }
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "DetailInterfaceController", context: rLabs[rowIndex])
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
