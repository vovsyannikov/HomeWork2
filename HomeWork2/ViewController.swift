//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import ObjectiveC

class ViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    
    var counter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(systemName: "at")
        
        counter = 0
    }

    @IBAction func pictureUp(_ sender: Any) {
        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        self.present(imagePicker, animated: true) {
//            self.imageView.image = imagePicker.pickedImage
//        }
        
        imagePicker.getImage(for: self)
        
    }
    
    @IBAction func doStuff(_ sender: Any) {
        performSegueWithIdentifier(identifier: "Swizzle", sender: self) { (segue) in
            self.counter += 1
            let dest = segue.destination as! SecondViewController
            dest.text = "Hello world! #\(self.counter!)"
        }
    }
}
