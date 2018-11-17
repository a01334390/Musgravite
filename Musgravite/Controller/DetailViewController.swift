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
import SVProgressHUD
import Alamofire

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //Laboratory information
    var labInformation:JSON?
    var selectedElementURL:URL?
    var panonoImage:UIImage?
    
    //Static Elements
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var bigTitleOutlet: UITextView!
    @IBOutlet weak var bigImageOutlet: UIImageView!
    @IBOutlet weak var gradientCategory: UIImageView!
    //CollectionViews
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var modelCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.black)
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
    
    /* Downloads the required data from an URL */
    func getData(_ dataURL: String, _ fileType:String, _ segueIdentifier:String) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent((URL(string: dataURL)?.lastPathComponent)!)
            return (documentsURL, [.removePreviousFile])
        }
        SVProgressHUD.show(withStatus: "Descargando \(fileType)...")
        Alamofire.download(dataURL, to: destination).responseData { response in
            SVProgressHUD.dismiss()
            self.selectedElementURL = response.destinationURL
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
    
    func getImage(_ dataURL: String, _ fileType: String, _ segueIdentifier:String) {
        SVProgressHUD.show(withStatus: "Descargando \(fileType)...")
        Alamofire.request(dataURL).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    SVProgressHUD.dismiss()
                    self.panonoImage = UIImage(data: data)
                    self.performSegue(withIdentifier: segueIdentifier, sender: self)
                }
            }}
    }
    
    /* Handles what happens to the 3DDome Segue */
    @IBAction func present3DDome(_ sender: Any) {
        getImage(labInformation!["panono"].stringValue, "imagen 3D", "ARDomeViewController")
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
            cell.image.image = UIImage(named: "grad12")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            return
        } else if collectionView.tag == 2 {
            getData(labInformation!["video"].arrayValue[indexPath.item].stringValue, "video", "VideoViewController")
        } else if collectionView.tag == 3 {
            getData(labInformation!["material"].arrayValue[indexPath.item].stringValue, "modelo", "ModelViewController")
        } else {
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideoViewController" {
            if let destination = segue.destination as? VideoViewController {
                destination.videoURL = selectedElementURL
            }
        } else if segue.identifier == "ModelViewController" {
            if let destination = segue.destination as? ModelViewController {
                destination.modelURL = selectedElementURL
            }
        } else if segue.identifier == "ARDomeViewController" {
            if let destination = segue.destination as? ARDomeViewController {
                destination.panonoImage = panonoImage
            }
        } else {
            return
        }
    }
}
