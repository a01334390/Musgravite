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
import Hero
import SVProgressHUD

/**
 This is an extension to create round images for avatar and what not
 - Remarks: This is out of the explorer to keep things neat
 */
extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    /* Main Menu Cards */
    let mainMenu = MainMenuCards()
    /* Bulletin board */
    lazy var bulletinManager: BLTNItemManager = {
        let introPage = mainMenu.createOnboardingExperience()
        return BLTNItemManager(rootItem: introPage)
    }()
    /* Support */
    let locationManager = CLLocationManager()
    /* Haptic Feeback */
    public let impact = UIImpactFeedbackGenerator()
    public let notification = UINotificationFeedbackGenerator()
    public let selection = UISelectionFeedbackGenerator()
    /* UIImage for the user */
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        setLabelsDate()
        self.navigationController?.isNavigationBarHidden = true
    }
    /**
     It returns the current date in the desired language
     - Returns: Nothing
     - Remark: Changes the current page text for the date
     - Requires: Nothing
     */
    func setLabelsDate(){
        let currentDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .full
        let dateString = dateFormat.string(from: currentDate)
        dateLabel.text = dateString
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
    
    override func viewDidAppear(_ animated: Bool) {
        if (appHasBeenLaunchedBefore()){
            self.notification.notificationOccurred(.warning)
            bulletinManager.backgroundViewStyle = .dimmed
            bulletinManager.showBulletin(above: self)
        } else {
            let cdResult = UtilityFunctions().getUsersData()
            if cdResult == "" {
                nameLabel.text = "CEDETEC"
            }else{
                nameLabel.text = "Hola \(cdResult)"
            }
            let cdIResult = UtilityFunctions().getUsersAvatar()
            userAvatarImage.image = cdIResult
            userAvatarImage.setRounded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMenu.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.imageView.image = UIImage(named: mainMenu.images[indexPath.item])
        cell.titleLabel.text = mainMenu.titles[indexPath.item]
        cell.subtitleLabel.text = mainMenu.subtitles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: mainMenu.targets[indexPath.item])
        self.navigationController?.pushViewController(destinationVC, animated: true)
        self.selection.selectionChanged()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false
    }
}

