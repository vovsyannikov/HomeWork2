//
//  NamesViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 08.10.2020.
//

import UIKit
import Bond
import ReactiveKit

class NamesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var names = MutableObservableArray([String]())
    let nameCollection = [
        "Никита",
        "Влад",
        "Виталий",
        "Виктор",
        "Алексей",
        "Николай",
        "Александр",
        
        "Нина",
        "Светлана",
        "Катя",
        "Алиса",
        "Вика",
        "Наталья",
        "Лиза"
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func namesInit() {
            let count = (1...3).randomElement()!
            for _ in 1...count {
                names.append(nameCollection.randomElement()!)
            }
        }
        
        namesInit()

        names.bind(to: tableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameTableViewCell") as! NameTableViewCell
            
            cell.nameLabel.text = dataSource[indexPath.row]
            
            return cell
        }
    }
    
    @IBAction func push(_ sender: Any) {
        names.insert(nameCollection.randomElement()!, at: 0)
    }
    
    @IBAction func pop(_ sender: Any) {
        names.removeLast()
    }
}
