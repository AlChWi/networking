//
//  PostsViewController.swift
//  networking
//
//  Created by Алексей Перов on 8/3/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    
    private var user: User?
    private var posts: [Post] = [] {
        didSet {
            self.items.removeAll(where: {$0 is Post})
            items.append(contentsOf: posts)
            postsTableView.reloadData()
        }
    }
    private var items: [Any] = [] {
        didSet {
            postsTableView.reloadData()
        }
    }
    var refreshControl = UIRefreshControl()


    @IBOutlet weak var postsTableView: UITableView! {
        didSet {
            postsTableView.delegate = self
            postsTableView.dataSource = self
            postsTableView.tableFooterView = UIView()
            let nib = UINib(nibName: "TableViewCell", bundle: nil)
            postsTableView.register(nib, forCellReuseIdentifier: "postNibCell")
            let nibb = UINib(nibName: "BiggerUserTableViewCell", bundle: nil)
            postsTableView.register(nibb, forCellReuseIdentifier: "userNibCell")
        }
    }
    
    @objc func reloadTableData() {
        if let existingUser = user {
            NetworkManager().getPosts(byId: existingUser.id) { (posts) in
                DispatchQueue.main.async {
                    self.posts = posts
                    self.refreshControl.endRefreshing()
                    self.postsTableView.tableFooterView = UIView()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(reloadTableData), for: UIControl.Event.valueChanged)
        postsTableView.addSubview(refreshControl)
        
        self.title = "\(user?.name ?? "user")'s posts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingScreen))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        self.items.insert(user as Any, at: 0)
        
        if let existingUser = user {
            
            let loadingIndicator = UIActivityIndicatorView()
            let indicatorBckg = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
            indicatorBckg.addSubview(loadingIndicator)
            indicatorBckg.backgroundColor = .white

            loadingIndicator.style = .gray
            
            loadingIndicator.frame.origin.x = postsTableView.tableFooterView!.frame.midX
            loadingIndicator.center.y = indicatorBckg.frame.midY
            postsTableView.tableFooterView = indicatorBckg
            
            loadingIndicator.startAnimating()

            NetworkManager().getPosts(byId: existingUser.id) { (posts) in
                DispatchQueue.main.async {
                    self.posts = posts
                    loadingIndicator.stopAnimating()
                    self.postsTableView.tableFooterView = UIView()
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let selectedRow: IndexPath? = postsTableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            postsTableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }
    @objc func presentAddingScreen() {
        let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddingPostsNavVCId") as! UINavigationController
        let vc = navVC.viewControllers[0] as! AddingPostsTableViewController
        vc.delegate = self
        vc.adjustForAddingContext(user: user!)
        self.present(navVC, animated: true)
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    func configure(_ user: User) {
        self.user = user
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        if item is User {
            let cell = postsTableView.dequeueReusableCell(withIdentifier: "userNibCell") as! BiggerUserTableViewCell
            cell.configure(item as! User)
            cell.isUserInteractionEnabled = false
            return cell
        }
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "postNibCell", for: indexPath) as! TableViewCell
        cell.configure(post: items[indexPath.row] as! Post)
        
        return cell

    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVCId") as! CommentsViewController
        vc.configure(items[indexPath.row] as! Post, user: user!)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NetworkManager().deletePost(items[indexPath.row] as! Post) {
                DispatchQueue.main.async {
                    self.items.remove(at: indexPath.row)
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
            let navVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddingPostsNavVCId") as! UINavigationController
            if let vc = navVC.viewControllers[0] as? AddingPostsTableViewController {
                vc.adjustForEditingContext(post: self.items[indexPath.row] as! Post, indexPath: indexPath)
                vc.delegate = self
                self.present(navVC, animated: true)
            }
            self.postsTableView.reloadData()
            completionHandler(true)
        }
        
        let actionsConfig = UISwipeActionsConfiguration(actions: [editAction])
        return actionsConfig
    }
}
extension PostsViewController: AddingPostsDelegate {
    func addPost(post: Post) {
        if let window = UIApplication.shared.keyWindow {
            let alertView = NotificationView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: -100, width: 50, height: 100))
            alertView.layer.cornerRadius = 8
            alertView.layer.masksToBounds = true
            alertView.configureMessage("Adding post")
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
            NetworkManager().postCreatePost(post) { (post) in
                DispatchQueue.main.async {
                    self.items.append(post)
                    alertView.removeFromSuperview()
                }
            }
        }
    }
    
    func editPost(post: Post, indexPath: IndexPath) {
        if let window = UIApplication.shared.keyWindow {
            let alertView = NotificationView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: -100, width: 50, height: 100))
            alertView.layer.cornerRadius = 8
            alertView.layer.masksToBounds = true
            alertView.configureMessage("Editing post")
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
            NetworkManager().putEditPost(post) { (recievedPost) in
                DispatchQueue.main.async {
                    self.items[indexPath.row] = recievedPost
                    self.postsTableView.reloadData()
                    alertView.removeFromSuperview()
                }
            }
        }
    }
    
    func displayError() {
        print("error")
    }
    
    
}
