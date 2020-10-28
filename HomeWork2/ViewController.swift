//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit

let randomImageURL = URL(string: "https://picsum.photos/1280/720")!

class ViewController: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressLabel.text = "Ожидание ввода"
    }

    @IBAction func download(_ sender: Any) {
        progressLabel.text = "Загружается картинка..."
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            let data = (try? Data(contentsOf: randomImageURL))!
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                [unowned self] in
                progressLabel.text = "Готово!"
                imageView.image = image
            }
        }
    }
    
}

