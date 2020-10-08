//
//  CounterViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 08.10.2020.
//

import UIKit
import Bond
import ReactiveKit

class CounterViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    var counter = Property(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counter
            .observeNext { self.counterLabel.text = "\($0)" }
        
    }

    @IBAction func add(_ sender: Any) {
        counter.value += 1
    }
}
