//
//  AppDelegate.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import FBSDKCoreKit
import VK_ios_sdk
import Swifter
import Firebase
import FirebaseUI

// AppDelegate.swift
@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        
        VKSdk.initialize(withAppId: "7648783")?.uiDelegate = self
        
        FirebaseApp.configure()
        
        return true
    }
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
        VKSdk.processOpen(url, fromApplication: options[.sourceApplication] as? String)
        
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        
        Swifter.handleOpenURL(url, callbackURL: urlToShare)
        
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        
        return true
    }
    
}

extension AppDelegate: VKSdkUIDelegate{
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        if let keyWindow = UIApplication.shared.windows
            .filter({$0.isKeyWindow}).first {
            let vc = keyWindow.rootViewController
            if vc?.presentedViewController != nil {
                vc?.dismiss(animated: false) {
                    print("Hiding \(String(describing: vc?.description))")
                    
                    vc?.present(controller, animated: true) {
                        print("Presenting \(controller.description)")
                    }
                }
            } else {
                vc?.present(controller, animated: true) {
                    print("Opening \(controller.description) through Safari")
                    VKSdk.authorize(vkPermissions)
                }
                
            }
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("Need to enter captcha")
    }
    
    func vkSdkWillDismiss(_ controller: UIViewController!) {
        print(VKSdk.isLoggedIn())
        if VKSdk.isLoggedIn() {
            controller.dismiss(animated: true) {
                print("Dismissed")
            }
        }
    }
}

