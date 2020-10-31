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
        
        setUpVStack()
        
        
        vStack.addArrangedSubview(createFBLoginButton())
        vStack.addArrangedSubview(createFBShareButton())
        addSpacer(for: "ВКонтакте")
        
        
        view.addSubview(vStack)
        
    }
    
    func setUpVStack(){
        
        vStack.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        vStack.distribution = .fillEqually
        vStack.axis = .vertical
        vStack.center = view.center
        
        addSpacer(for: "FaceBook")
    }
    func addSpacer(for name: String) {
        let spacerLabel = UILabel()
        spacerLabel.text = name
        
        vStack.addArrangedSubview(spacerLabel)
    }
    
    func createFBLoginButton() -> FBLoginButton {
        let fbLogin = FBLoginButton()
        
        fbLogin.delegate = self
        fbLogin.permissions = ["email", "public_profile"]
        fbLogin.center = view.center
        
        return fbLogin
    }
    func createFBShareButton() -> FBShareButton {
        let fbShare = FBShareButton()
        let fbContentToShare: SharingContent = ShareLinkContent()
        fbContentToShare.contentURL = URL(string: "https://www.skillbox.ru")!
        
        fbShare.center = view.center
        fbShare.shareContent = fbContentToShare
        
        return fbShare
    }
    
}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        print("_____________________________")
        
        switch result {
        case .some(let res):
            print(res.grantedPermissions)
        case .none:
            print("++++++++")
        }
        
        if error != nil {
            print("Error -> \(error!)")
        }
        
        print("_____________________________")
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
