//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func download(_ sender: Any) {
        Loader.download()
    }
    
}

