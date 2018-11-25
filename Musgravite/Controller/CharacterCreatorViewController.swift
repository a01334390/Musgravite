//
//  ViewController.swift
//  CharacterCreatorDEMO
//
//  Created by Fernando Martin Garcia Del Angel on 11/1/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import BLTNBoard

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

class CharacterCreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    /* Bulletin Board */
    lazy var inBulletin: BLTNItemManager = {
        let introPage = createAvatarCreatorPage()
        return BLTNItemManager(rootItem: introPage)
    }()
    
    lazy var outBulletin: BLTNItemManager = {
        let introPage = successAvatarCreator()
        return BLTNItemManager(rootItem: introPage)
    }()
    
    /* Haptic Feeback */
    public let impact = UIImpactFeedbackGenerator()
    public let notification = UINotificationFeedbackGenerator()
    public let selection = UISelectionFeedbackGenerator()
    
    /* Storage for selected types */
    var selectedEthnicity = 1
    var selectedBodyType = 1
    var selectedEyeColor = 1
    var selectedEyeType = 1
    var selectedHairColor = 1
    var selectedHairType = 1
    var selectedShoes = 2
    var selectedCostume = 1
    var female:Bool = true
    
    /* Image outlets for the Character Creator */
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var ethnicityOutlet: UIImageView!
    @IBOutlet weak var headOutlet: UIImageView!
    @IBOutlet weak var eyeOutlet: UIImageView!
    @IBOutlet weak var hairOutlet: UIImageView!
    @IBOutlet weak var shoesOutlet: UIImageView!
    @IBOutlet weak var costumeOutlet: UIImageView!
    @IBOutlet weak var suitOutlet: UIImageView!
    @IBOutlet weak var background: UIImageView!
    
    /* Outlet for the image picker */
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ethnicityOutlet.image = UIImage(named: "F01-1")
        imagePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "characterLaunchedBefore") {
            inBulletin.backgroundViewStyle = .dimmed
            inBulletin.showBulletin(above: self)
            UserDefaults.standard.set(true, forKey: "characterLaunchedBefore")
        }
    }
    
    func universalUpdater(){
        if(female){
            ethnicityOutlet.image = UIImage(named: "F0\(selectedBodyType)-\(selectedEthnicity)")
            headOutlet.image = UIImage(named: "head-\(selectedEthnicity)")
            ethnicityOutlet.image = UIImage(named: "F0\(selectedBodyType)-\(selectedEthnicity)")
            shoesOutlet.image = UIImage(named: "S0\(selectedBodyType)-1-\(selectedShoes)")
            suitOutlet.image = nil
            costumeOutlet.image = UIImage(named: "C0\(selectedBodyType)-1-\(selectedCostume)")
        }else{
            ethnicityOutlet.image = UIImage(named: "F0\(selectedBodyType)-\(selectedEthnicity + 5)")
            headOutlet.image = UIImage(named: "head-\(selectedEthnicity)")
            ethnicityOutlet.image = UIImage(named: "F0\(selectedBodyType)-\(selectedEthnicity + 5)")
            shoesOutlet.image = UIImage(named: "S0\(selectedBodyType)-1-\(selectedShoes + 5)")
            costumeOutlet.image = nil
            suitOutlet.image = UIImage(named: "C0\(selectedBodyType)-6-\(selectedCostume)")
        }
    }

    /* Method to change character's ethnicity
     SENDER: Multiple buttons on the ethnicity view
     ACTION: Changes the ethnicity of the character
    */

    @IBAction func changeEthnicity(sender : AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        selectedEthnicity = button.tag
        selection.selectionChanged()
        universalUpdater()
    }
    
    /* Method to change body type
       SENDER : Multiple buttons on the body view
       ACTION : Changes the body type of the character
    */
    
    @IBAction func changeBodyType(sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        /* Male and Female types are misslabeled */
        if(button.tag < 5){
            female = true
            selectedBodyType = button.tag
        } else {
            female = false
            selectedBodyType = button.tag - 4
        }
        selection.selectionChanged()
        universalUpdater()
    }
    
    /* Method to change eye color
       SENDER : Any eye colour button
       ACTION : Changes the eye color of the subject
    */
    
    @IBAction func changeEyeColor(sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        selection.selectionChanged()
        selectedEyeColor = button.tag
        eyeOutlet.image = UIImage(named: "E0\(selectedEyeType)-\(selectedEyeColor)")
    }
    
    /* Method change eye type
     SENDER : Any eye type button
     ACTION : Changes the eye type of the subject
    */
    
    @IBAction func changeEyeType(sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        selection.selectionChanged()
        selectedEyeType = button.tag
        eyeOutlet.image = UIImage(named: "E0\(selectedEyeType)-\(selectedEyeColor)")
    }
    
    /* Method to change the hair color
     SENDER : Any hair color button
     ACTION : Changes the hair color of the subject
    */
    
    @IBAction func changeHairColor(sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        selection.selectionChanged()
        selectedHairColor = button.tag
        hairOutlet.image = UIImage(named: "H0\(selectedHairType)-\(selectedHairColor)")
    }
    
    /* Method to change the hair type
     SENDER : Any hair type button
     ACTION : Changes the hair type of the subject
    */
    
    @IBAction func changeHairType(sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        selection.selectionChanged()
        selectedHairType = button.tag
        hairOutlet.image = UIImage(named: "H0\(selectedHairType)-\(selectedHairColor)")
    }
    
    /* Method to change shoes
     SENDER : Any shoe type button
     ACTION : Changes the shoe type of the subject
     */
    
    @IBAction func changeShoes(sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
       
        if(female){
            selectedShoes = button.tag
        }else{
            selectedShoes = button.tag
        }
        selection.selectionChanged()
        universalUpdater()
    }
    
    
    @IBAction func changeCostume(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        selection.selectionChanged()
        selectedCostume = button.tag
        universalUpdater()
    }
    
    @IBAction func selectBackground(_ sender: Any) {
        notification.notificationOccurred(.warning)
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            background.contentMode = .scaleAspectFit
            background.image = pickedImage
            impact.impactOccurred()
        }
        dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAvatar(_ sender: Any) {
        let avatar = avatarView.asImage()
        UIImageWriteToSavedPhotosAlbum(avatar,nil,nil,nil)
        UtilityFunctions().storeUserAvatar(avatarView.asImage())
        notification.notificationOccurred(.success)
        outBulletin.backgroundViewStyle = .dimmed
        outBulletin.showBulletin(above: self)
    }
    
    /* Dont allow the ViewController to appear */
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    func createAvatarCreatorPage() -> BLTNPageItem{
        let page = BLTNPageItem(title:"Bienvenido al creador de avatares")
        page.isDismissable = true
        page.image = UIImage(named: "buletin-character")
        page.descriptionText = "Selecciona entre las muchas opciones para crear al avatar que te acompanara en la aplicacion."
        page.appearance.actionButtonColor = UIColor(red:0.20, green:0.14, blue:0.14, alpha:1.0)
        page.actionButtonTitle = "Empezar"
        page.requiresCloseButton = false
        page.appearance.shouldUseCompactDescriptionText = true
        page.actionHandler = { item in
            self.notification.notificationOccurred(.success)
            item.manager?.dismissBulletin()
        }
        return page
    }
    
    func successAvatarCreator() -> BLTNPageItem{
        let page = BLTNPageItem(title: "Personaje terminado")
        page.image = UIImage(named: "buletin-4")
        page.imageAccessibilityLabel = "Checkmark"
        page.appearance.actionButtonColor = UIColor(red:0.04, green:0.40, blue:0.14, alpha:1.0)
        page.appearance.imageViewTintColor = UIColor(red:0.04, green:0.40, blue:0.14, alpha:1.0)
        page.appearance.actionButtonTitleColor = .white
        page.descriptionText = "Has creado a tu personaje satisfactoriamente. Ahora tu personaje aparecera a lo largo de la aplicacion"
        page.actionButtonTitle = "Empecemos"
        page.requiresCloseButton = false
        page.isDismissable = true
        page.actionHandler = { item in
            UserDefaults.standard.set(true,forKey: "characterLaunchedBefore")
            item.manager?.dismissBulletin(animated: true)
            self.selection.selectionChanged()
            _ = self.navigationController?.popViewController(animated: true)
        }
        return page
    }
}

