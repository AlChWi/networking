//
//  CommentsViewController.swift
//  networking
//
//  Created by Алексей Перов on 7/25/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentsTableView: UITableView! {
        didSet {
            commentsTableView.dataSource = self
            commentsTableView.delegate = self
            let nib = UINib(nibName: "CommentsTableViewCell", bundle: nil)
            commentsTableView.register(nib, forCellReuseIdentifier: "commentNibCell")
            commentsTableView.tableFooterView = UIView()
        }
    }
    
    private var user: User?
    private var post: Post?
    private var comments: [Comment] = [] {
        didSet {
            self.commentsTableView.reloadData()
        }
    }
    var refreshControl = UIRefreshControl()

    @objc func reloadTableData() {
        if let existingPost = post {
            NetworkManager().getComments(byPostId: existingPost.id) { (comments) in
                DispatchQueue.main.async {
                    self.comments = comments
                    self.refreshControl.endRefreshing()
                    self.commentsTableView.tableFooterView = UIView()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(reloadTableData), for: UIControl.Event.valueChanged)
        commentsTableView.addSubview(refreshControl)
        
        self.title = "Comments"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingScreen))
        
        if let existingPost = post {
            NetworkManager().getComments(byPostId: existingPost.id) { (comments) in
                DispatchQueue.main.async {
                    self.comments = comments
                }
            }
        }
    }
    @objc func presentAddingScreen() {
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddingCommentsNavVCId") as! UINavigationController
        let vc = navVC.viewControllers[0] as! AddingCommentsTableViewController
        vc.delegate = self
        vc.adjustForAddingContext(post: post!, user: user!)
        self.present(navVC, animated: true)
    }
    
    func configure(_ post: Post, user: User) {
        self.post = post
        self.user = user
    }
 
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "commentNibCell", for: indexPath) as! CommentsTableViewCell
        cell.configure(comment: comments[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NetworkManager().deleteComment(comments[indexPath.row]) {
                DispatchQueue.main.async {
                    self.comments.remove(at: indexPath.row)
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
            let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddingCommentsNavVCId") as! UINavigationController
            if let vc = navVC.viewControllers[0] as? AddingCommentsTableViewController {
                vc.adjustForEditingContext(comment: self.comments[indexPath.row], indexPath: indexPath)
                vc.delegate = self
                self.present(navVC, animated: true)
            }
            self.commentsTableView.reloadData()
            completionHandler(true)
        }
        
        let actionsConfig = UISwipeActionsConfiguration(actions: [editAction])
        return actionsConfig
    }
}
extension CommentsViewController: AddingCommentsDelegate {
    func addComment(comment: Comment) {
        if let window = UIApplication.shared.keyWindow {
            let alertView = NotificationView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: -100, width: 50, height: 100))
            alertView.layer.cornerRadius = 8
            alertView.layer.masksToBounds = true
            alertView.configureMessage("Adding comment")
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
            NetworkManager().postCreateComment(comment) { (comment) in
                DispatchQueue.main.async {
                    self.comments.append(comment)
                    alertView.removeFromSuperview()
                }
            }
        }
    }
    
    func editComment(comment: Comment, indexPath: IndexPath) {
        if let window = UIApplication.shared.keyWindow {
            let alertView = NotificationView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: -100, width: 50, height: 100))
            alertView.layer.cornerRadius = 8
            alertView.layer.masksToBounds = true
            alertView.configureMessage("Editing comment")
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
            NetworkManager().putEditComment(comment) { (recievedComment) in
                DispatchQueue.main.async {
                    self.comments[indexPath.row] = recievedComment
                    self.commentsTableView.reloadData()
                    alertView.removeFromSuperview()
                }
            }
        }
    }
    
    func displayError() {
        print("error")
    }
    
    
}
