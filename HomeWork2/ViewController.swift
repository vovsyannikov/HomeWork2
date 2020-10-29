//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import ObjectiveC

class ViewController: UIViewController {
    
    @IBOutlet weak var fuckingButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var counter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counter = 0
    }

    @IBAction func doStuff(_ sender: Any) {
        performSegueWithIdentifier(identifier: "Swizzle", sender: self) { (segue) in
            self.counter += 1
            let dest = segue.destination as! SecondViewController
            print(dest)
            dest.text = "Hello world! #\(self.counter!)"
        }
    }
}


