//
//  AppDelegate.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = WindowBuilder.build()

        return true
    }
}

