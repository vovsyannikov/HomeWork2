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

import VK_ios_sdk

class ViewController: UIViewController  {
    
    var vStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVStack()
        
        addSpacer(for: "FaceBook")
        createFBLoginButton()
        createFBShareButton()
        addSpacer(for: "ВКонтакте")
        createVKLoginButton()
        createVKShareButton()
        
        view.addSubview(vStack)
        
    }
    
    // Выставление вертикального стека ...
    func setUpVStack(){
        
        vStack.frame = CGRect(x: 0, y: 0, width: 150, height: 400)
        
        //... с равным заполнением
        vStack.distribution = .fillEqually
        
        // ... вертикально
        vStack.axis = .vertical
        
        // ... с центром в центре экрана со смещением влево
        vStack.center = CGPoint(x: view.center.x - 50, y: view.center.y)
        
        // ... с дополнительной прослойкой между элементами
        vStack.spacing = 5
        
    }
    func addSpacer(for name: String) {
        let spacerLabel = UILabel()
        spacerLabel.text = name
        spacerLabel.numberOfLines = 0
        
        vStack.addArrangedSubview(spacerLabel)
    }
    
    func createFBLoginButton() {
        let fbLogin = FBLoginButton()
        
        fbLogin.delegate = self
        fbLogin.permissions = ["email", "public_profile"]
        fbLogin.center = view.center
        
        vStack.addArrangedSubview(fbLogin)
        
    }
    func createFBShareButton() {
        let fbShare = FBShareButton()
        let fbContentToShare: SharingContent = ShareLinkContent()
        fbContentToShare.contentURL = URL(string: "https://www.skillbox.ru")!
        
        fbShare.center = view.center
        fbShare.shareContent = fbContentToShare
        
        
        vStack.addArrangedSubview(fbShare)
    }
    
    func createVKLoginButton(){
        let vkLogin = UIButton()
        let auth = UIAction{ (act) in
            VKSdk.authorize(["email", "wall"])
        }
        
        vkLogin.addAction(auth, for: .allTouchEvents)
        vkLogin.setTitle("Вход через ВК", for: .normal)
        vkLogin.backgroundColor = UIColor.systemBlue
        
        vStack.addArrangedSubview(vkLogin)
    }
    func createVKShareButton(){
        let vkShare = UIButton()
        let share = UIAction { (act) in
            let vkShareController = VKShareDialogController()
            vkShareController.shareLink =
                VKShareLink.init(title: "Skillbox", link: URL(string: "https://www.skillbox.ru")!)
            vkShareController.text = "Это окно сделано с помощью #VKSDK_iOS"
            
            vkShareController.dismissAutomatically = true
            self.present(vkShareController, animated: true) {
                print("Opening \(vkShareController)")
                
            }
        }
        
        vkShare.addAction(share, for: .allTouchEvents)
        vkShare.setTitle("Поделиться", for: .normal)
        vkShare.backgroundColor = UIColor.systemBlue
        
        vStack.addArrangedSubview(vkShare)
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

