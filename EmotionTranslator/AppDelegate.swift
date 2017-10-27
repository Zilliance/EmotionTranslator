//
//  AppDelegate.swift
//  EmotionTranslator
//
//  Created by Philip Dow on 8/27/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit
import ZillianceShared
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // App wide appearance
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .navBar
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.muliBold(size: 18)
        ]
        
        var rootViewController: UIViewController?
        
        if UserDefaults.standard.bool(forKey: "IntroShown") {
            let sideMenuViewController = CustomSideViewController()
            sideMenuViewController.setupHome()
            rootViewController = sideMenuViewController
        }
        else {
            UserDefaults.standard.set(true, forKey: "IntroShown")
            rootViewController = UIStoryboard(name: "Intro", bundle: nil).instantiateInitialViewController()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        NotificationsManager.sharedInstance.realmDB = Database.shared.realm
        Analytics.shared.initialize()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        AppEventsLogger.activate(application)
        
    }

}

// Quickie Model Tests

extension AppDelegate {
    func checkMonsterAssets() {
        
        // All color images
        let _ = Monster.Color.all.map { $0.image }
        
        // All mouth images
        let _ = Monster.Mouth.all.map { $0.image }
        
        // All eyes images
        let _ = Monster.Eyes.all.map { $0.image }
        
        // All shape images for all colors
        let _ = Monster.Shape.all.flatMap({ (shape) in
            return Monster.Color.all.map({ (color) in
                return shape.image(with: color)
            })
        })
        
        // All hair images for all colors
        let _ = Monster.Hair.all.flatMap({ (hair) in
            return Monster.Color.all.map({ (color) in
                return hair.image(with: color)
            })
        })
        
        // For example, get all shape images of a certain color
        let _ = Monster.Shape.all.map { $0.image(with: .red) }
        
        // For example, get all hair images of a certain color
        let _ = Monster.Hair.all.map { $0.image(with: .blue) }
    }
}
