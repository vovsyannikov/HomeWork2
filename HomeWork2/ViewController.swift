//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import Bond

enum DomainNames: String, CaseIterable, CustomStringConvertible {
    case ru
    case com
    
    var description: String { "\(rawValue)"}
    static func contains(_ str: String) -> Bool {
        for c in allCases {
            if c.rawValue == str {
                return true
            }
        }
        return false
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    
    func checkPasswordFormat(for pass: String) -> Bool {
        return !(pass.count != 0 && pass.count < 6)
    }
    func checkLoginFormat(for login: String) -> Bool {
        var result = false
        if login.count != 0{
            var check: [(index: Int, char: String)] = []
            var foundAt = false
            var foundStop = false
            var tempCheck = (index: 1000, char: "")
            for (index, char) in login.enumerated() {
                if index == 0 && char == "@" {
                    break
                } else {
                    if char == "@" {
                        foundAt = true
                        tempCheck.index = index
                        tempCheck.char = "\(char)"
                        check.append(tempCheck)
                        tempCheck.char = ""
                        tempCheck.index += 1
                    } else if char == "." {
                        foundStop = true
                        tempCheck.char = "\(tempCheck.char.dropFirst())"
                        check.append(tempCheck)
                        tempCheck.index = index
                        tempCheck.char = ""
                    }
                    if foundAt || foundStop {
                        tempCheck.char.append(char)
                    }
                }
            }
            check.append(tempCheck)
            
            if check.count == 3{
                if check[0].index < check[2].index
                    && check[0].index != check[2].index - 1
                    && DomainNames.contains("\(check[2].char.dropFirst())") {
                    result = true
                }
            }
        }
        return result || login.isEmpty
    }
    
    func loginHandler() {
        
        var loginErrorString: String { "Неверный формат почты.\n '<имя>@<домен>.\(DomainNames.allCases)'" }
        
        loginTextField.reactive.text
            .ignoreNils()
            .map { self.checkLoginFormat(for: $0) ? "" : loginErrorString }
            .bind(to: messageLabel.reactive.text)
        
        loginTextField.reactive.text
            .ignoreNils()
            .combineLatest(with: passwordTextField.reactive.text.ignoreNils())
            .map{ [self] in
                    checkLoginFormat(for: $0)
                    && checkPasswordFormat(for: $1)
                    && $0.count > 0
                    && $1.count > 0
            }
            .bind(to: sendButton.reactive.isEnabled)
    }
    
    func passwordHandler() {
        passwordTextField.reactive.text
            .ignoreNils()
            .map { self.checkPasswordFormat(for: $0) ? "" : "Слишком короткий пароль" }
            .bind(to: messageLabel.reactive.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = ""
        
        loginHandler()
        passwordHandler()
    }
}

