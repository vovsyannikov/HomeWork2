//
//  FriendsViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 03.11.2020.
//

import UIKit

class FriendsViewController: UIViewController {
    
    var friends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Loaded \(self)", "Friends = \(friends)", separator: "\n")
    }
    
}

extension FriendsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendTableViewCell
        let friend = friends[indexPath.row]
        
        cell.nameLabel.text = friend.name
        cell.iconImageView.image = friend.icon
        
        return cell
    }
    
    
}
