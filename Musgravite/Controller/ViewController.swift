//
//  ViewController.swift
//  Musgravite
//
//  Created by Fernando Martin Garcia Del Angel on 11/3/18.
//  Copyright © 2018 Aabo Technologies. All rights reserved.
//

import UIKit
import OnboardKit

class ViewController: UIViewController {
    /* This will allow Haptic Feedback to work */
    let impact = UIImpactFeedbackGenerator()
    let notification = UINotificationFeedbackGenerator()
    let selection = UISelectionFeedbackGenerator()
    
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
     - Returns: nil
     - Remark: After the onboarding has completed, the app will not show the experience anymore
     - Requires: The application to be launched for the first time and the process to have completed
     */
    func launchOnboardingExperience(){
        let page = OnboardPage(title: "Welcome to OnboardKit",
                               imageName: "Onboarding1",
                               description: "OnboardKit helps you add onboarding to your iOS app")
        let pageFour = OnboardPage(title: "Notifications",
                                   imageName: "Onboarding4",
                                   description: "Turn on notifications to get reminders and keep up with your goals.",
                                   advanceButtonTitle: "Decide Later",
                                   actionButtonTitle: "Enable Notifications",
                                   action: { [weak self] completion in
                                    print("wow")})
        let pageFive = OnboardPage(title: "All Ready",
                                   imageName: "buletin-1",
                                   description: "You are all set up and ready to use Habitat. Begin by adding your first habit.",
                                   advanceButtonTitle: "Done")

        let onboardingViewController = OnboardViewController(pageItems: [page,pageFour,pageFive])
            onboardingViewController.presentFrom(self, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (appHasBeenLaunchedBefore()){
            launchOnboardingExperience()
        }
    }
    
}

