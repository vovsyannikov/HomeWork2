//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit

import FBSDKLoginKit
import FBSDKShareKit

import VK_ios_sdk

import SwifteriOS

let urlToShare = URL(string: "https://www.skillbox.ru")!

class ViewController: UIViewController  {
    
    var vStackLeft = UIStackView()
    var vStackRight = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpStacks()
        
        addSpacer(for: "Вход/Поделиться", to: vStackLeft)
        addSpacer(for: "Друзья", to: vStackRight)
        addSpacer(for: "FaceBook", to: vStackLeft)
        createFBLoginButton()
        createFBShareButton()
        addSpacer(for: "ВКонтакте", to: vStackLeft)
        createVKLoginButton()
        createVKShareButton()
        addSpacer(for: "Twitter", to: vStackLeft)
        createTwitterLoginButton()
    
        
    }
    
    // Выставление вертикального стека ...
    func setUpStacks(){
        let hStack = UIStackView()
        
        hStack.frame = CGRect(x: 0, y: 0, width: view.frame.size.width - 75, height: 400)
        vStackLeft.frame = CGRect(x: 0, y: 0, width: 175, height: 400)
        vStackRight.frame = CGRect(x: 0, y: 0, width: 175, height: 400)
        
        //... с равным заполнением
        vStackLeft.distribution = .fillEqually
        vStackRight.distribution = .fillEqually
        hStack.distribution = .fillEqually
        
        // ... вертикально
        vStackLeft.axis = .vertical
        vStackRight.axis = .vertical
        hStack.axis = .horizontal
        
        // ... с центром в центре экрана со смещением
        hStack.center = view.center
        
        // ... с дополнительной прослойкой между элементами
        hStack.spacing = 10
        vStackLeft.spacing = 5
        vStackRight.spacing = 5
        
        // Для выравнивания элементов обоих стеков по верхней границе
//        hStack.alignment = .top
        
        hStack.addArrangedSubview(vStackLeft)
        hStack.addArrangedSubview(vStackRight)
        
        view.addSubview(hStack)
    }
    func addSpacer(for name: String, to stack: UIStackView) {
        let spacerLabel = UILabel()
        spacerLabel.text = name
        spacerLabel.numberOfLines = 0
        
        if stack.subviews.count == 0{
            spacerLabel.textColor = .systemRed
            spacerLabel.font = .italicSystemFont(ofSize: spacerLabel.font.pointSize)
            //MARK: Бонус к предыдущему уроку и курсу
            spacerLabel.text?.insert(" ", at: spacerLabel.text!.startIndex)
        }
        
        stack.addArrangedSubview(spacerLabel)
    }
    
    //MARK: Facebook
    func createFBLoginButton() {
        let fbLogin = FBLoginButton()
        
        fbLogin.delegate = self
        fbLogin.permissions = ["email", "public_profile"]
        fbLogin.center = view.center
        
        vStackLeft.addArrangedSubview(fbLogin)
        
    }
    func createFBShareButton() {
        let fbShare = FBShareButton()
        let fbContentToShare: SharingContent = ShareLinkContent()
        fbContentToShare.contentURL = urlToShare
        
        fbShare.center = view.center
        fbShare.shareContent = fbContentToShare
        
        
        vStackLeft.addArrangedSubview(fbShare)
    }
    
    //MARK: VK
    func createVKLoginButton(){
        let vkLogin = UIButton()
        let auth = UIAction{ _ in
            VKSdk.authorize(["email", "wall", "friends"])
        }
        
        vkLogin.addAction(auth, for: .touchUpInside)
        vkLogin.setTitle("Вход через ВК", for: .normal)
        vkLogin.backgroundColor = UIColor.systemBlue
        
        vStackLeft.addArrangedSubview(vkLogin)
    }
    func createVKShareButton(){
        let vkShare = UIButton()
        let share = UIAction { _ in
            let vkShareController = VKShareDialogController()
            
            vkShareController.shareLink = VKShareLink(title: "Skillbox", link: urlToShare)
            vkShareController.text = "Это окно сделано с помощью #VKSDK_iOS"
            vkShareController.dismissAutomatically = true
            
            self.present(vkShareController, animated: true) {
                print("Opening \(vkShareController)")
                
            }
        }
        
        vkShare.addAction(share, for: .touchUpInside)
        vkShare.setTitle("Поделиться", for: .normal)
        vkShare.backgroundColor = UIColor.systemBlue
        
        vStackLeft.addArrangedSubview(vkShare)
    }
    
    //MARK: Twitter
    //MARK: TODO: Add keys to twitterLogin
    func createTwitterLoginButton(){
        let twitterButton = UIButton()
        let auth = UIAction { _ in
            let twitterLogin = Swifter(consumerKey: "", consumerSecret: "")
            twitterLogin.authorize(withCallback: urlToShare, presentingFrom: self) { (token, response) in
                print("Token = \(token.debugDescription)", "Response = \(response)", separator: "\n")
            }
            
            print("Action made")
        }
        
        twitterButton.addAction(auth, for: .touchUpInside)
        twitterButton.backgroundColor = UIColor.systemBlue
        twitterButton.setTitle("Вход через Twitter", for: .normal)
        
        vStackLeft.addArrangedSubview(twitterButton)
    }
    
}

//MARK: Facebook Login BTN Delegate
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

