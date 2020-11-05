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

import FirebaseUI

let urlToShare = URL(string: "https://www.skillbox.ru")!

class ViewController: UIViewController  {
    
    var vStackLeft = UIStackView()
    var vStackRight = UIStackView()
    
    //MARK: TODO: Add keys to twitterLogin
    private let TWITTER_CONSUMER_KEY = ""
    private let TWITTER_SECRET_KEY = ""
    
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
        createTwitterShareButton()
        addSpacer(for: "Google", to: vStackLeft)
        createGoogleLoginButton()
        
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
    func createTwitterLoginButton(){
        let twitterButton = UIButton()
        let auth = UIAction { [unowned self] _ in
            let twitterHandler = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_SECRET_KEY)
            twitterHandler.authorize(withCallback: urlToShare, presentingFrom: self) { (token, response) in
                print("Token = \(token.debugDescription)", "Response = \(response)", separator: "\n")

            }
            
            print("Action made")
        }
        
        twitterButton.addAction(auth, for: .touchUpInside)
        twitterButton.backgroundColor = UIColor.systemBlue
        twitterButton.setTitle("Вход через Twitter", for: .normal)
        
        vStackLeft.addArrangedSubview(twitterButton)
    }
    func createTwitterShareButton(){
        let twitterShare = UIButton()
        let share = UIAction { [unowned self] _ in
            let twitterHandler = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_SECRET_KEY)
            
            twitterHandler.postTweet(status: "Test" , media: urlToShare.dataRepresentation)
            
        }
        
        twitterShare.addAction(share, for: .touchUpInside)
        twitterShare.backgroundColor = .systemBlue
        twitterShare.setTitle("Твитнуть", for: .normal)
        
        vStackLeft.addArrangedSubview(twitterShare)
//        let someButton = UIButton()
//        let action = UIAction { _ in
//            self.performSegue(withIdentifier: "FriendsList", sender: someButton)
//        }
//
//        someButton.addAction(action, for: .touchUpInside)
//        someButton.backgroundColor = .black
//
//        vStackRight.addArrangedSubview(someButton)
    }
    
    //MARK: Google
    func createGoogleLoginButton(){
        let authUI = FUIAuth.defaultAuthUI()
//        let authProviders = [FUIGoogleAuth, FUIFace]
        authUI?.delegate = self
        authUI?.providers.append(FUIGoogleAuth())
        
        let googleLogin = UIButton()
        let auth = UIAction { _ in
            let authViewController = authUI?.authViewController()
            self.present(authViewController!, animated: true) {
                print("Presenting \(String(describing: authViewController))")
                print(authUI?.auth as Any)
            }
        }
        
        
        googleLogin.addAction(auth, for: .touchUpInside)
        googleLogin.backgroundColor = .systemGray
        googleLogin.setTitle("Вход через Google", for: .normal)
        
        vStackLeft.addArrangedSubview(googleLogin)
    }
}

//MARK: Facebook Delegate
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
        print("Did Logout from Facebook")
    }
    
    
}

//MARK: VK Delegate
extension ViewController: VKSdkDelegate{
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("VK result > \(String(describing: result))")
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Failed auth from VK")
    }
    
    
}

//MARK: Google Delegate
extension ViewController: FUIAuthDelegate{
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print("The user is \(String(describing: authDataResult?.user.providerData)) with \(authUI)")
        if error != nil {
            print("Google error > \(String(describing: (error)))")
        }
    }
}
