//
//  UsersViewController.swift
//  networking
//
//  Created by Алексей Перов on 7/25/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView! {
        didSet {
            usersTableView.dataSource = self
            usersTableView.delegate = self
            let nib = UINib(nibName: "UsersTableViewCell", bundle: nil)
            usersTableView.register(nib, forCellReuseIdentifier: "userNibCell")
        }
    }
    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager().getAllUsers() { users in
            self.users = users
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
            }
        }
    }
    
}
extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "userNibCell", for: indexPath) as! UsersTableViewCell
        cell.configure(users[indexPath.row])
        
        return cell
        
    }
    
    
}
