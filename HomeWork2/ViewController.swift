//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createFBButton()
        
    }
    
    func createFBButton(){
        let fbLogin = FBLoginButton()
        fbLogin.delegate = self
        fbLogin.permissions = ["email"]
        fbLogin.center = view.center
        
        view.addSubview(fbLogin)
    }
    
}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        print("result = \(result?.grantedPermissions), error = \(error)")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did Logout ")
    }
    
    
}
