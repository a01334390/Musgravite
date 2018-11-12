//
//  AboutPageViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /* View Outlets */
    @IBOutlet weak var photoOutlet: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var uniqueIDOutlet: UILabel!
    @IBOutlet weak var githubOutlet: UILabel!
    @IBOutlet weak var websiteOutlet: UILabel!
    @IBOutlet weak var avatarOutlet: UIImageView!
    
    /* Haptic Feeback */
    public let impact = UIImpactFeedbackGenerator()
    public let notification = UINotificationFeedbackGenerator()
    public let selection = UISelectionFeedbackGenerator()
    
    /* Data generator */
    let names = ["Fernando Martin Garcia Del Angel","Armando Hernandez Vargas"]
    let identifier = ["A01334390","A01334390"]
    let githandler = ["@A01334390","@A01334390"]
    let portfolio = ["martntn.com","armandomando.com"]
    let personImages = ["grad15","grad16"]
    let avatarImages = ["grad17","grad18"]

    override func viewDidLoad() {
        super.viewDidLoad()
        avatarOutlet.setRounded()
    }
    
    /* Dont allow the ViewController to appear */
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AboutCollectionViewCell", for: indexPath) as! AboutCollectionViewCell
        cell.image.image = UIImage(named: personImages[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nameOutlet.text = names[indexPath.item]
        uniqueIDOutlet.text = identifier[indexPath.item]
        githubOutlet.text = githandler[indexPath.item]
        websiteOutlet.text = portfolio[indexPath.item]
        avatarOutlet.image = UIImage(named: avatarImages[indexPath.item])
        photoOutlet.image = UIImage(named: personImages[indexPath.item])
    }
}
