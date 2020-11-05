//
//  FriendsViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 03.11.2020.
//

import UIKit

class FriendsViewController: UIViewController {

    var friends: [(icon: UIImage, name: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension FriendsViewController: UITableViewDelegate{
    
}
