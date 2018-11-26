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
import SwiftMessages
import WatchConnectivity
import MapKit
import CoreMedia
import AVFoundation

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, WCSessionDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    /* WCSessionDelegate */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    
    //Laboratory information
    var labInformation:JSON?
    var selectedElementURL:URL?
    var panonoImage:UIImage?
    
    /* WatchKit */
    var wcSession:WCSession!
    
    /* Haptic Feeback */
    public let impact = UIImpactFeedbackGenerator()
    public let notification = UINotificationFeedbackGenerator()
    public let selection = UISelectionFeedbackGenerator()
    
    //Static Elements
    @IBOutlet weak var mapOutlet: MKMapView!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UITextView!
    @IBOutlet weak var bigTitleOutlet: UITextView!
    @IBOutlet weak var bigImageOutlet: UIImageView!
    @IBOutlet weak var gradientCategory: UIImageView!
    @IBOutlet weak var watchSend: UIButton!
    
    
    //CollectionViews
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var modelCollectionView: UICollectionView!
    @IBOutlet weak var button360: UIButton!
    @IBOutlet weak var button3D: UIButton!
    
    // CLLocationManager
    let locationManager = CLLocationManager()
    
    @IBAction func SwapMode(_ sender: Any) {
        if(button3D.isHidden == true){
            button3D.isHidden = false
            button360.isHidden = true
        }
        else if(button360.isHidden == true){
            button3D.isHidden = true
            button360.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SVProgressHUD.setDefaultMaskType(.black)
        presentStaticContent()
        /* WatchKit connectivity */
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
//            if wcSession.isPaired {
//                watchSend.isHidden = true
//            }
        }
        button3D.isHidden = true
        /* MapKit Delegate */
        mapOutlet.delegate = self
        mapOutlet.showsPointsOfInterest = true
        mapOutlet.showsScale = true
        mapOutlet.showsUserLocation = true
        displayMapDirections()
    }
    
    func displayMapDirections(){
        let sourceCoordinates = locationManager.location?.coordinate
        let destinationCoordinates = CLLocationCoordinate2D(latitude: (labInformation?["coordinates"].arrayValue[0].doubleValue)!, longitude: (labInformation?["coordinates"].arrayValue[1].doubleValue)!)
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .walking
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {response, error in
            guard let response = response else {
                if let error = error {
                    print("omg something went wrong")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapOutlet.addOverlay(route.polyline, level: .aboveRoads)
            let rekt = route.polyline.boundingMapRect
            self.mapOutlet.setRegion(MKCoordinateRegion(rekt), animated: true)
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    @IBAction func sendToAppleMaps(_ sender: Any) {
        let sourceCoordinates = locationManager.location?.coordinate
        let destinationCoordinates = CLLocationCoordinate2D(latitude: (labInformation?["coordinates"].arrayValue[0].doubleValue)!, longitude: (labInformation?["coordinates"].arrayValue[1].doubleValue)!)
        let directionsURL = "http://maps.apple.com/?saddr=\(sourceCoordinates?.latitude ?? 0),\(sourceCoordinates?.longitude ?? 0)&daddr=\(destinationCoordinates.latitude),\(destinationCoordinates.longitude)"
        guard let url = URL(string: directionsURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func sendToWatch(_ sender: Any) {
        sendLabInformation(labInformation!)
    }
    
    func sendLabInformation(_ json:JSON){
        do {
            let data = try json.rawData()
            wcSession.sendMessageData(data, replyHandler: nil, errorHandler: {error in print(error.localizedDescription)})
            SwiftMessages.hide()
            // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
            // files in the main bundle first, so you can easily copy them into your project and make changes.
            let view = MessageView.viewFromNib(layout: .cardView)
            
            // Theme message elements with the warning style.
            view.configureTheme(.info)
            
            // Add a drop shadow.
            view.configureDropShadow()
            
            // Set message title, body, and icon. Here, we're overriding the default warning
            // image with an emoji character.
            let iconText = ["⌚"].sm_random()!
            view.configureContent(title: "Enviado", body: "El laboratorio ha sido enviado al reloj", iconText: iconText)
            
            // Increase the external margin around the card. In general, the effect of this setting
            // depends on how the given layout is constrained to the layout margins.
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            
            // Reduce the corner radius (applicable to layouts featuring rounded corners).
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: .statusBar)
            
            
            // Show the message.
            SwiftMessages.show(config: config, view: view)
        } catch let error {
            print(error.localizedDescription)
        }
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
        bigImageOutlet.sd_setImage(with: URL(string: labInformation!["PosterImage"].stringValue),placeholderImage: UIImage(named: "grad0"))
        /* Create map value */
        
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
            self.selection.selectionChanged()
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
                    self.selection.selectionChanged()
                    self.performSegue(withIdentifier: segueIdentifier, sender: self)
                }
            }}
        
    }
    
    /* Handles what happens to the 3DDome Segue */
    @IBAction func present3DDome(_ sender: Any) {
        getImage(labInformation!["panono"].stringValue, "imagen 3D", "ARDomeViewController")
    }
    
    /* Handles what happens to the 360Dome Segue */
    @IBAction func present360Dome(_ sender: Any) {
        getImage(labInformation!["panono"].stringValue, "imagen 3D", "P360ViewController")
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
            cell.title.text = URL(string: labInformation!["video"].arrayValue[indexPath.item].stringValue)?.lastPathComponent
            DispatchQueue.global(qos: .background).async {
                let dimage = self.downloadThumbnail(self.labInformation!["video"].arrayValue[indexPath.item].stringValue)
                DispatchQueue.main.async {
                    cell.image.image = dimage
                }
            }
            return cell
        } else if collectionView.tag == 3 {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelCellView", for: indexPath) as! ModelCollectionViewCell
            cell.image.image = UtilityFunctions().getRandomBackground()
            cell.label.text = URL(string: labInformation!["material"].arrayValue[indexPath.item].stringValue)?.lastPathComponent
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func downloadThumbnail(_ path:String) -> UIImage {
        do {
            let asset = AVURLAsset(url: URL(string: path)! , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return UIImage()
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
        selection.selectionChanged()
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
        } else if segue.identifier == "P360ViewController" {
            if let destination = segue.destination as? P360ViewController {
                destination.panonoImage = panonoImage
            }
            return
        }
    }
}
