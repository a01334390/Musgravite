//
//  DetailViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //Laboratory information
    var labInformation:JSON?
    
    //Static Elements
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var bigTitleOutlet: UITextView!
    @IBOutlet weak var bigImageOutlet: UIImageView!
    @IBOutlet weak var gradientCategory: UIImageView!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var modelCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentStaticContent()
    }
    /*
     This method presents all data that is static and available w/o parsing
    */
    func presentStaticContent() {
        locationOutlet.text = labInformation!["ubicacion"].stringValue
        if labInformation!["descripcion"].stringValue == "" {
            descriptionOutlet.text = "Este laboratorio no tiene descripcion"
        }else{
            descriptionOutlet.text = labInformation!["descripcion"].stringValue
        }
        bigTitleOutlet.text = labInformation!["nombre"].stringValue
        /* To be changed once this information is available */
        bigImageOutlet.image = UIImage(named: "grad17")
        gradientCategory.image = UIImage(named: "grad13")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return (labInformation!["imagen"].arrayObject?.count)!
        }else if collectionView.tag == 2{
            return (labInformation!["video"].arrayObject?.count)!
        }else if collectionView.tag == 3 {
            return (labInformation!["material"].arrayObject?.count)!
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataImageCollectionViewCell", for: indexPath) as! DataImageCollectionViewCell
            cell.image.sd_setImage(with: URL(string: labInformation!["imagen"].arrayValue[indexPath.item].stringValue),placeholderImage: UIImage(named: "grad0"))
            return cell
        }else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoDetailCollectionViewCell", for: indexPath) as! VideoDetailCollectionViewCell
            cell.title.text = labInformation!["video"].arrayValue[indexPath.item].stringValue
            cell.image.image = UIImage(named: "grad11")
            return cell
        } else if collectionView.tag == 3 {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelCellView", for: indexPath) as! ModelCollectionViewCell
            cell.image.image = UIImage(named: "grad12")
            cell.label.text = labInformation!["material"].arrayValue[indexPath.item].stringValue
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
