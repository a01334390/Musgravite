//
//  LaboratorySearchViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class LaboratorySearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    /* Elements on the interface */
    @IBOutlet weak var bigImageOutlet: UIImageView!
    @IBOutlet weak var bigTitleOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var floorsCollectionView: UICollectionView!
    @IBOutlet weak var labsTableView: UITableView!
    
    /* Information for the interface */
    var floorData:JSON?
    var labByFloorData:[JSON]?
    var labData:JSON?
    var superFiltered:[JSON]?
    
    /* Selected floor variable - To show information in the table view */
    var selectedFloor = -1
    /* Haptic Feeback */
    public let impact = UIImpactFeedbackGenerator()
    public let notification = UINotificationFeedbackGenerator()
    public let selection = UISelectionFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
    }
    /*
     Retrieves the information for the interface as a JSON
    */
    func retrieveData(){
        floorData = LabCards().retrieveFloorData()
        labData = LabCards().retrieveLabData()
        labByFloorData = filterLabArray()
    }
    
    /* Dont allow the ViewController to appear */
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingToParent {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    func filterLabArray() -> [JSON]{
        var temp:[JSON]?
        temp = labData?.arrayValue.filter({$0["piso"].stringValue.contains(String(selectedFloor))})
        return temp!
    }
    
    //MARK - CollectionView Elements
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (floorData?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabCell", for: indexPath) as! LabCell
        cell.title.text = (floorData?.arrayValue[indexPath.item]["name"].stringValue)!
        cell.image.image = UIImage(named: "grad1\(indexPath.item)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bigTitleOutlet.text = floorData?.arrayValue[indexPath.item]["name"].stringValue
        descriptionOutlet.text = floorData?.arrayValue[indexPath.item]["description"].stringValue
        selectedFloor = (floorData?.arrayValue[indexPath.item]["cod"].intValue)!
        labByFloorData = filterLabArray()
        labsTableView.reloadData()
        bigImageOutlet.image = UIImage(named: "grad1\(indexPath.item)")
        self.selection.selectionChanged()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (labByFloorData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labCells", for: indexPath) as! LabTableViewCell
        cell.title.text = labByFloorData![indexPath.item]["nombre"].stringValue
        cell.location.text = labByFloorData![indexPath.item]["ubicacion"].stringValue
        return cell
    }
}
