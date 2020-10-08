//
//  RocketViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 08.10.2020.
//

import UIKit
import Bond
import ReactiveKit

class RocketViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    var greenButtonPressed = Property(false)
    var redButtonPressed = Property(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputLabel.text = "Введите код"
        
        greenButton.reactive.tap
            .observeNext { self.greenButtonPressed.value = true }
        redButton.reactive.tap
            .observeNext { self.redButtonPressed.value = true }
        
        greenButtonPressed
            .combineLatest(with: redButtonPressed)
            .filter { $0 && $1 }
            .map { _ in "Ракета запущена" }
            .bind(to: outputLabel)
    }
    
}
