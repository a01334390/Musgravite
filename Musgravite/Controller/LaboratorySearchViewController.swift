//
//  LaboratorySearchViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import SDWebImage

extension UITableView {
    /* Allows the user to set a title, message and image to an empty table view*/
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


class LaboratorySearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    /* Elements on the interface */
    @IBOutlet weak var bigImageOutlet: UIImageView!
    @IBOutlet weak var bigTitleOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var floorsCollectionView: UICollectionView!
    @IBOutlet weak var labsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /* Information for the interface */
    var floorData:JSON?
    var labByFloorData:[JSON]?
    var labData:JSON?
    var superFiltered:[JSON]?
    var searchFiltered:[JSON]?
    var isSearching = false
    
    /* Selected floor variable - To show information in the table view */
    var selectedFloor = -1
    /* Haptic Feeback */
    public let impact = UIImpactFeedbackGenerator()
    public let notification = UINotificationFeedbackGenerator()
    public let selection = UISelectionFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        retrieveData()
    }
    
    /*
     Retrieves the information for the interface as a JSON
    */
    func retrieveData(){
        labByFloorData = filterLabArray()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    /* Dont allow the ViewController to appear */
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
             self.navigationController?.isNavigationBarHidden = true
        }
    }
    /* Filter Lab Array to the selected floor*/
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
        bigImageOutlet.sd_setImage(with: URL(string: floorData!.arrayValue[indexPath.item]["PosterImage"].stringValue),placeholderImage: UIImage(named: "grad5"))
        self.selection.selectionChanged()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            if (searchFiltered?.count)! == 0 {
                tableView.setEmptyView(title: "Sin laboratorios", message: "No hay laboratorios con ese nombre", messageImage: UIImage(named: "Nautilus")!)
            }else{
                tableView.restore()
            }
            return (searchFiltered?.count)!
        } else {
            if (labByFloorData?.count)! == 0 {
                tableView.setEmptyView(title: "Sin laboratorios", message: "Aún no has seleccionado un piso", messageImage: UIImage(named: "Nautilus")!)
            }else{
                tableView.restore()
            }
            return (labByFloorData?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labCells", for: indexPath) as! LabTableViewCell
            cell.title.text = searchFiltered![indexPath.item]["nombre"].stringValue
            cell.location.text = searchFiltered![indexPath.item]["ubicacion"].stringValue
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labCells", for: indexPath) as! LabTableViewCell
            cell.title.text = labByFloorData![indexPath.item]["nombre"].stringValue
            cell.location.text = labByFloorData![indexPath.item]["ubicacion"].stringValue
            
            return cell
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            labsTableView.reloadData()
        } else {
            isSearching = true
            searchFiltered = labData?.arrayValue.filter({$0["nombre"].stringValue.contains(searchText)})
            labsTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        var selectedLab:JSON?
        if isSearching {
            selectedLab = searchFiltered![(labsTableView.indexPathForSelectedRow?.row)!]
        } else {
            selectedLab = labByFloorData![(labsTableView.indexPathForSelectedRow?.row)!]
        }
        vc.labInformation = selectedLab
    }
}
