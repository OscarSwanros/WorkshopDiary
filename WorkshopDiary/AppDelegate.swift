//
//  AppDelegate.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        // Note View Controllers
        let noteViewController = InboxViewController()
        let noteViewControllerNav = UINavigationController(rootViewController: noteViewController)

        window?.rootViewController = noteViewControllerNav
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        return true
    }

}

