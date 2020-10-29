//
//  SecondViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 29.10.2020.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var someLabel: UILabel!
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        someLabel.text = text
        print(text)
    }

}
