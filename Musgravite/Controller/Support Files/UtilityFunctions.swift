//
//  UtilityFunctions.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/10/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UtilityFunctions {
    private let gradientImages = 20
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /*
    Returns a random UIImage from the Gradient Library
    Remarks : This should work fairly fast, but does consume more energy
    Return: UIImage with a gradient
    */
    
    func getRandomBackground() -> UIImage{
        let upper_bound = (gradientImages + 1)
        return UIImage(named: "grad\(arc4random_uniform(UInt32(upper_bound)))")!
    }
    
    /*
    Stores an user's username in CoreData
    Parameters : An username's username (or name)
    Returns : Nothing
    Remarks: If more tables are added to Core Data, this should move to its own class
     */
    func storeUserName(_ username:String){
        //Create an entity
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        //Create a new user
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        //Add that user's data
        newUser.setValue(username, forKey: "name")
        //Store it in CoreData
        do {
            try context.save()
        } catch {
            print("Failed Saving")
        }
    }
    
    /* Stores an user's image in CoreData
     Parameters: An user's avatar
     Returns : Nothing
     Remarks: If more tables are added to Core Data, this should move to its own class
     */
    func storeUserAvatar(_ avatar:UIImage){
        //Create an userFetch to read information on our user
        let userFetch = NSFetchRequest<User>(entityName: "User")
        //We want to fetch one record
        do {
            let fetchResults = try context.fetch(userFetch)
            if fetchResults.count > 0 {
                let userObject:User = fetchResults[0]
                userObject.setValue(avatar.pngData(), forKey: "avatar")
                do {
                    try context.save()
                } catch {
                    print("Failed Saving")
                }
            }
        }catch let error as Error {
            print(error.localizedDescription)
        }
    }
    
    /* Retrieve the user's data from CoreData
    Parameters: None
    Returns: String and Image
    Remarks: If more tables are added to Core Data, this should move to its own class
    */
    
    func getUsersData() -> String {
        //Create an userFetch to read information on our user
        let userFetch = NSFetchRequest<User>(entityName: "User")
        //We want to fetch one record
        do {
            let fetchResults = try context.fetch(userFetch)
            if fetchResults.count > 0 {
                let userObject:User = fetchResults[0]
                return userObject.name!
            }
        }catch let error as Error {
            print(error.localizedDescription)
        }
        return ""
    }
    
    func getUsersAvatar() -> UIImage {
        //Create an userFetch to read information on our user
        let userFetch = NSFetchRequest<User>(entityName: "User")
        //We want to fetch one record
        do {
            let fetchResults = try context.fetch(userFetch)
            if fetchResults.count > 0 {
                let userObject:User = fetchResults[0]
                let imageData = userObject.avatar
                if imageData == nil {
                    return UIImage(named: "64x64")!
                }else {
                    return UIImage(data: imageData!) ?? UIImage(named: "64x64")!
                }
            }
        }catch let error as Error {
            print(error.localizedDescription)
        }
        return UIImage()
    }
}
