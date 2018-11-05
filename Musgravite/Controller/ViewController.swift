//
//  ViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/3/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import BLTNBoard
import CoreLocation

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let image = images[indexPath.item]
        let title = titles[indexPath.item]
        let subtitle = subtitles[indexPath.item]
        cell.imageView.image = UIImage(named: image)
        cell.titleLabel.text = title
        cell.subtitleLabel.text = subtitle
        return cell
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate{
    /* Bulletin board */
    lazy var bulletinManager: BLTNItemManager = {
        let introPage = createOnboardingExperience()
        return BLTNItemManager(rootItem: introPage)
    }()
    /* Support */
    let locationManager = CLLocationManager()
    let images = ["img1","img2","img3","img4"]
    let titles = ["Crea tu propio avatar","Busca laboratorios","Hablanos de tu experiencia","Modifica tus preferencias"]
    let subtitles = ["Personaliza tu experiencia virtual","¡Crea tu siguiente inovacion ahora!","Queremos saber tus opiniones","Ajustes, Localizacion, Siri y demás"]
    /* Haptic Feeback */
    public let impact = UIImpactFeedbackGenerator()
    public let notification = UINotificationFeedbackGenerator()
    public let selection = UISelectionFeedbackGenerator()
    /* UIImage for the user */
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userAvatarImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAvatarImage.setRounded()
    }
    
    /**
     It checks if the app has been launched before
     - Returns: A boolean declaring if the app was launched before
     - Remark: After first launch, it will also update the application status
     - Requires: The application to be launched and this method to be run from viewDidLoad
    */
    func appHasBeenLaunchedBefore() -> Bool{
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            return false
        } else {
            return true
        }
    }
    
    /**
       This launches the onboarding experience on first launch
     - Returns: OnboardingBLTNPageItem
     - Remark: After the onboarding has completed, the app will not show the experience anymore
     - Requires: The application to be launched for the first time and the process to have completed
     */
    func createOnboardingExperience() -> BLTNPageItem {
        let firstPage = BLTNPageItem(title: "Bienvenido a Musgravite")
        firstPage.image = UIImage(named: "buletin-1")
        firstPage.descriptionText = "Descubre los laboratorios que existen en CEDETEC y crea tu siguiente innovacion"
        firstPage.actionButtonTitle = "Configurar"
        firstPage.appearance.actionButtonTitleColor = .white
        firstPage.appearance.actionButtonColor = .purple
        firstPage.alternativeButtonTitle = "Ahora no"
        firstPage.requiresCloseButton = false
        firstPage.isDismissable = false
        firstPage.next = createLocationServicesBLTNPage()
        firstPage.actionHandler = { item in
            self.selection.selectionChanged()
            item.manager?.displayNextItem()
        }
        firstPage.alternativeHandler = { item in
            self.selection.selectionChanged()
            item.manager?.dismissBulletin(animated: true)
        }
        return firstPage
    }
    
    /**
     This launches the location services BLTN Page
     - Returns: OnboardingBLTNPageItem
     - Remark: This should call our support file for location services
     - Requires: It requires to be called by another BTLNPage and is not the first page to show
     */
    func createLocationServicesBLTNPage() -> BLTNPageItem {
        let firstPage = BLTNPageItem(title: "Servicios de Localizacion")
        firstPage.image = UIImage(named: "buletin-2")
        firstPage.descriptionText = "Para personalizar tu experiencia necesitamos tu localizacion. Esta informacion sera enviada a nuestros servidores de forma anonima. Puedes cambiar de opinion mas adelante en las preferencias de la aplicacion."
        firstPage.actionButtonTitle = "Activar Localizacion"
        firstPage.alternativeButtonTitle = "Ahora no"
        firstPage.requiresCloseButton = false
        firstPage.isDismissable = false
        firstPage.appearance.shouldUseCompactDescriptionText = true
        firstPage.next = createNotificationServicesBLTNPage()
        firstPage.actionHandler = { item in
            self.getLocation()
            self.selection.selectionChanged()
            item.manager?.displayNextItem()
        }
        firstPage.alternativeHandler = { item in
            self.selection.selectionChanged()
            item.manager?.displayNextItem()
        }
        return firstPage
    }
    
    /** This launches the Notification services BLTN Page
    - Returns : OnboardingBLTNPageItem
    - Remark : This should call our support file for Notification services
    - Requires : It requires to be called by another BLTNPage and is not our first page
    */
    
    func createNotificationServicesBLTNPage() -> BLTNPageItem {
        let firstPage = BLTNPageItem(title: "Notificaciones Push")
        firstPage.image = UIImage(named: "buletin-3")
        firstPage.descriptionText = "Recibe notificaciones push cuando cambios en la aplicacion sucedan."
        firstPage.actionButtonTitle = "Activar notificaciones"
        firstPage.alternativeButtonTitle = "Ahora no"
        firstPage.requiresCloseButton = false
        firstPage.isDismissable = false
        firstPage.appearance.shouldUseCompactDescriptionText = true
        firstPage.next = createSuccessBLTNPage()
        firstPage.actionHandler = { item in
            item.manager?.displayNextItem()
            self.notification.notificationOccurred(.success)
        }
        firstPage.alternativeHandler = { item in
            item.manager?.displayNextItem()
            self.notification.notificationOccurred(.success)
        }
        return firstPage
    }
    
    /** This launches the Success BLTN Page
    - Returns : OnboardingBLTNPageItem
    - Remark : This should call our Success file
    - Requires : To be called last, this is our last BLTNPage
    */
    
    func createSuccessBLTNPage() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Configuracion completa")
        page.image = UIImage(named: "buletin-4")
        page.imageAccessibilityLabel = "Checkmark"
        page.appearance.actionButtonColor = .green
        page.appearance.imageViewTintColor = .green
        page.appearance.actionButtonTitleColor = .white
        page.descriptionText = "Musgravite esta lista para usarse, ¡A crear algo nuevo!"
        page.actionButtonTitle = "Empecemos"
        page.alternativeButtonTitle = "Volver a intentarlo"
        page.requiresCloseButton = false
        page.isDismissable = true
        page.dismissalHandler = { item in
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.selection.selectionChanged()
        }
        
        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            self.selection.selectionChanged()
        }
        
        page.alternativeHandler = { item in
            item.manager?.popToRootItem()
            self.selection.selectionChanged()
        }
        
        return page
    }
    
    /*
     This method gets the chance to receive the location of the user
     - Remark : This calls location services
     - Requires : Privacy settings on the plist file
    */
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if (appHasBeenLaunchedBefore()){
            /* Launch Onboarding */
            self.notification.notificationOccurred(.warning)
            bulletinManager.backgroundViewStyle = .blurredExtraLight
            bulletinManager.showBulletin(above: self)
//        }
    }
    
}

