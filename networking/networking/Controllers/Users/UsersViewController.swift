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
    private var users: [User] = [] {
        didSet {
            usersTableView.reloadData()
        }
    }
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager().getAllUsers() { users in
            DispatchQueue.main.async {
                self.users = users
            }
        }
        refreshControl.addTarget(self, action: #selector(reloadTableData), for: UIControl.Event.valueChanged)
        usersTableView.addSubview(refreshControl)
    }
    @objc func reloadTableData() {
        NetworkManager().getAllUsers { (users) in
            DispatchQueue.main.async {
                self.users = users
                self.refreshControl.endRefreshing()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let selectedRow: IndexPath? = usersTableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            usersTableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }
    
    @IBAction func presentAddingScreen(_ sender: Any) {
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddingUsersNavVCId") as! UINavigationController
        let vc = navVC.viewControllers[0] as! AddingUsersTableViewController
        vc.delegate = self
        self.present(navVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostsVCId") as! PostsViewController
        vc.configure(users[indexPath.row])
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            completionHandler(true)
        }
     
        let actionsConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return actionsConfig
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddingUsersNavVCId") as! UINavigationController
            if let vc = navVC.viewControllers[0] as? AddingUsersTableViewController {
                vc.adjustForEditingContext(user: self.users[indexPath.row], indexPath: indexPath)
                vc.delegate = self
                self.present(navVC, animated: true)
            }
            self.usersTableView.reloadData()
            completionHandler(true)
        }
        
        let actionsConfig = UISwipeActionsConfiguration(actions: [editAction])
        return actionsConfig
    }
}

extension UsersViewController: AddingUsersDelegate {
    func addUser(user: User) {
        NetworkManager().postCreateUser(user) { (user) in
            DispatchQueue.main.async {
                self.users.append(user)
            }
        }
    }
    
    func editUser(user: User, indexPath: IndexPath) {
        self.users[indexPath.row] = user
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
    }
    
    func displayError() {
        print("error")
    }
    
    
}
