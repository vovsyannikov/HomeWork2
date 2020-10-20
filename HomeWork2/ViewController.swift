//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit

class ViewController: UIViewController {

    let randomImageURL = URL(string: "https://picsum.photos/1280/720")!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func download(_ sender: Any) {
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            let data = (try? Data(contentsOf: self.randomImageURL))!
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                [unowned self] in
                self.imageView.image = image
            }
        }
    }
    
}

