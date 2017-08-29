//
//  AppDelegate.swift
//  EmotionTranslator
//
//  Created by Philip Dow on 8/27/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

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
            NSFontAttributeName: UIFont.muliBold(size: 16)
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
        
        //NotificationsManager.sharedInstance.realmDB = Database.shared.realm
        Analytics.initialize()
        Analytics.sendEvent(event: EmotionTranslatorEvent.newStressor)

        return true
    }


}

