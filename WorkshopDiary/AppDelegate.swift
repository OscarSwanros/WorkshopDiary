//
//  AppDelegate.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import UIKit
import WKDataClient

final class Analytics: DataSink {
    var priority: SinkPriority {
         return .high
    }

    var useForReading: Bool {
        return false
    }

    func write(entries: [DiaryEntry]) throws {
        // Crashlytics.log("entries_saved": entries.count)
    }

    func read() -> [DiaryEntry] {
        return []
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        WKDataClient.shared.delegate = self
        WKDataClient.shared.sinks.append(Analytics())

        // Note View Controllers
        let noteViewController = InboxViewController()
        let noteViewControllerNav = UINavigationController(rootViewController: noteViewController)

        window?.rootViewController = noteViewControllerNav
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        return true
    }

}

extension AppDelegate: WKDataClientDelegate {
    func dataClient(_ client: WKDataClient, shouldAdd entries: [DiaryEntry], to sink: DataSink) -> Bool {
        if let _ = sink as? Analytics {
            return false
        }

        return true
    }


    func dataClientShouldAddEntries(_ client: WKDataClient) -> Bool {
        return true
    }
}
