//
//  AppDelegate.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import FBSDKCoreKit

// AppDelegate.swift
@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        return true
    }
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
    }
    
}
