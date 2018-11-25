//
//  MainMenuCards.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import Foundation
import BLTNBoard
import CoreLocation

class MainMenuCards {
    
    /* Haptic Feeback */
    public let impact = UIImpactFeedbackGenerator()
    public let notification = UINotificationFeedbackGenerator()
    public let selection = UISelectionFeedbackGenerator()
    /* Data to be used in cards */
    let images = ["img1","img2","img3"]
    let titles = ["Crea tu propio avatar","Busca laboratorios","Acerca de la aplicacion"]
    let subtitles = ["Personaliza tu experiencia virtual","¡Crea tu siguiente inovacion ahora!","Autores detras de este proyecto"]
    let targets = ["CharacterCreatorViewController","LaboratorySearchViewController","AboutPageViewController"]
    /* Location */
    let locationManager = CLLocationManager()
    
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
        firstPage.next = createOnboardingUsername()
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
    
    /* Create a textfield onboarding that asks for this person's name
     - Returns: OnboardingBLTNPageItem
     - Remark: This returns a text
     */
    
    func createOnboardingUsername() -> BLTNPageItem {
        let page = TextFieldBulletinPage(title: "Permite que nos conozcamos mejor")
        page.isDismissable = false
        page.descriptionText = "Para crear tu perfil, requerimos tu nombre. Lo usaremos para personalizar tu experiencia."
        page.actionButtonTitle = "Crear perfil"
        page.textInputHandler = {(item,text) in
            //We need to store it in CoreData
            self.selection.selectionChanged()
            UtilityFunctions().storeUserName(text!)
            let next = self.showAvatarPageBLTNPage()
            item.manager?.push(item: next)
        }
        return page
    }
    
    func showAvatarPageBLTNPage() -> BLTNPageItem {
        let page = BLTNPageItem(title:"Crea tu propio avatar!")
        page.isDismissable = true
        page.image = UIImage(named: "buletin-character")
        page.descriptionText = "Selecciona en la primer opción el creador de Avatares dentro de la aplicación, este te seguirá a todos tus dispositivos"
        page.appearance.actionButtonColor = UIColor(red:0.20, green:0.14, blue:0.14, alpha:1.0)
        page.actionButtonTitle = "Continuar"
        page.requiresCloseButton = false
        page.appearance.shouldUseCompactDescriptionText = true
        page.next = showLabSearchBLTNPage()
        page.actionHandler = { item in
            self.selection.selectionChanged()
            item.manager?.displayNextItem()
        }
        return page
    }
    
    /** This launches the Notification services BLTN Page
     - Returns : OnboardingBLTNPageItem
     - Remark : This should call our support file for Notification services
     - Requires : It requires to be called by another BLTNPage and is not our first page
     */
    
    func showLabSearchBLTNPage() -> BLTNPageItem {
        let firstPage = BLTNPageItem(title: "Encuentra los laboratorios")
        firstPage.image = UIImage(named: "buletin-lab")
        firstPage.descriptionText = "Presiona el segundo elemento en el menu para ver los diferentes salones divididos por pisos de CDTC"
        firstPage.actionButtonTitle = "Continuar"
        firstPage.requiresCloseButton = false
        firstPage.isDismissable = false
        firstPage.appearance.shouldUseCompactDescriptionText = true
        firstPage.next = createLocationServicesBLTNPage()
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
        firstPage.next = createSuccessBLTNPage()
        firstPage.actionHandler = { item in
            /* Request Location */
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            self.selection.selectionChanged()
            item.manager?.displayNextItem()
        }
        firstPage.alternativeHandler = { item in
            self.selection.selectionChanged()
            item.manager?.displayNextItem()
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
        page.appearance.actionButtonColor = UIColor(red:0.04, green:0.40, blue:0.14, alpha:1.0)
        page.appearance.imageViewTintColor = UIColor(red:0.04, green:0.40, blue:0.14, alpha:1.0)
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
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            item.manager?.dismissBulletin(animated: true)
            self.selection.selectionChanged()
        }
        
        page.alternativeHandler = { item in
            item.manager?.popToRootItem()
            self.selection.selectionChanged()
        }
        
        return page
    }

}
