//
//  ViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/3/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import BLTNBoard

class ViewController: UIViewController {
    /* This will allow Haptic Feedback to work */
    let impact = UIImpactFeedbackGenerator()
    let notification = UINotificationFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    /* Bulletin board */
    lazy var bulletinManager: BLTNItemManager = {
        let introPage = createOnboardingExperience()
        return BLTNItemManager(rootItem: introPage)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
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
        firstPage.alternativeButtonTitle = "Ahora no"
        firstPage.requiresCloseButton = false
        firstPage.isDismissable = false
        firstPage.next = createLocationServicesBLTNPage()
        firstPage.actionHandler = { item in
            self.selection.selectionChanged()
            item.manager?.displayNextItem()
        }
        firstPage.alternativeHandler = { item in
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
        firstPage.actionHandler = { item in
            item.manager?.dismissBulletin()
        }
        firstPage.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        return firstPage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (appHasBeenLaunchedBefore()){
            /* Launch Onboarding */
            notification.notificationOccurred(.warning)
            bulletinManager.backgroundViewStyle = .blurredLight
            bulletinManager.showBulletin(above: self)
        }
    }
    
}

