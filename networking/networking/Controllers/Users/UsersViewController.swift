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
    private var transition = PopAnimator()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transition.dismissCompletion = { [weak self] in
            guard
                let selectedIndexPathCell = self?.usersTableView.indexPathForSelectedRow,
                let selectedCell = self?.usersTableView.cellForRow(at: selectedIndexPathCell)
                    as? UsersTableViewCell
                else {
                    return
            }
            
            selectedCell.shadowView.isHidden = false
        }
        
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
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostsNavVCId") as! UINavigationController
        let vc = navVC.viewControllers[0] as! PostsViewController
        navVC.transitioningDelegate = self
        vc.configure(users[indexPath.row])
    
        self.present(navVC, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NetworkManager().deleteUser(users[indexPath.row]) {
                DispatchQueue.main.async {
                    self.users.remove(at: indexPath.row)
                }
            }
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
        if let window = UIApplication.shared.keyWindow {
            let alertView = NotificationView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: -100, width: 50, height: 100))
            alertView.layer.cornerRadius = 8
            alertView.layer.masksToBounds = true
            alertView.configureMessage("Adding user")
            window.addSubview(alertView)
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            alertView.frame.origin.y = window.safeAreaInsets.top
                            alertView.frame.origin.x = window.safeAreaLayoutGuide.layoutFrame.origin.x + 10
                            alertView.frame.size.width = window.safeAreaLayoutGuide.layoutFrame.size.width - 20
                            
            },
                           completion: nil)
            NetworkManager().postCreateUser(user) { (user) in
                DispatchQueue.main.async {
                    self.users.append(user)
                    alertView.removeFromSuperview()
                }
            }
        }
    }
    
    func editUser(user: User, indexPath: IndexPath) {
        if let window = UIApplication.shared.keyWindow {
            let alertView = NotificationView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: -100, width: 50, height: 100))
            alertView.layer.cornerRadius = 8
            alertView.layer.masksToBounds = true
            alertView.configureMessage("Editing user")
            window.addSubview(alertView)
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            alertView.frame.origin.y = window.safeAreaInsets.top
                            alertView.frame.origin.x = window.safeAreaLayoutGuide.layoutFrame.origin.x + 10
                            alertView.frame.size.width = window.safeAreaLayoutGuide.layoutFrame.size.width - 20
                            
            },
                           completion: nil)
            NetworkManager().putEditUser(user) { (recievedUser) in
                DispatchQueue.main.async {
                    self.users[indexPath.row] = recievedUser
                    self.usersTableView.reloadData()
                    alertView.removeFromSuperview()
                }
            }
        }
    }
    func displayError() {
        print("error")
    }
}

extension UsersViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let selectedIndexPathCell = usersTableView.indexPathForSelectedRow,
            let selectedCell = usersTableView.cellForRow(at: selectedIndexPathCell)
                as? UsersTableViewCell,
            let selectedCellSuperview = selectedCell.superview
            else {
                return nil
        }
        
        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        transition.originFrame = CGRect(
            x: transition.originFrame.origin.x + 20,
            y: transition.originFrame.origin.y + 20,
            width: transition.originFrame.size.width - 40,
            height: transition.originFrame.size.height - 40
        )
        
        transition.presenting = true
        selectedCell.shadowView.isHidden = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
