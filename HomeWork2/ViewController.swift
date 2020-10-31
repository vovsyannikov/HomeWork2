//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController  {
    
    var vStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vStack.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        vStack.distribution = .fillEqually
        vStack.axis = .vertical
        vStack.center = view.center
        
        vStack.addArrangedSubview(createFBLoginButton())
        vStack.addArrangedSubview(createFBShareButton())
        
        
        view.addSubview(vStack)
        
    }
    
    func createFBLoginButton() -> FBLoginButton {
        let fbLogin = FBLoginButton()
        
        fbLogin.delegate = self
        fbLogin.permissions = ["email"]
        fbLogin.center = view.center
        
        return fbLogin
    }
    
    func createFBShareButton() -> FBShareButton {
        let fbShare = FBShareButton()
        let fbContentToShare: SharingContent = ShareLinkContent()
        fbContentToShare.contentURL = URL(string: "https://www.youtube.com")!
        
        let fbShareDialog = ShareDialog(fromViewController: self, content: fbContentToShare, delegate: self)
        
        fbShare.center = view.center
        fbShare.shareContent = fbContentToShare
        
        fbShareDialog.show()
        
        return fbShare
    }
    
}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        print("result = \(String(describing: result?.grantedPermissions)), error = \(String(describing: error))")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did Logout ")
    }
    
    
}

extension ViewController: SharingDelegate{
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        for res in results{
            print(res)
        }
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("Cancelled")
    }
    
    
}
