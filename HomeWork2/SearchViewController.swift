//
//  SearchViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 08.10.2020.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextfield.reactive.text
            .ignoreNils()
            .filter { $0.count > 0 }
            .debounce(for: 0.5)
            .observeNext { query in
                print("Выполняется запрос \"\(query)\"")
            }
    }

}
