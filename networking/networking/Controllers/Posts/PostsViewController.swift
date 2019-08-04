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
            postsTableView.reloadData()
        }
    }

    @IBOutlet weak var postsTableView: UITableView! {
        didSet {
            postsTableView.delegate = self
            postsTableView.dataSource = self
            let nib = UINib(nibName: "TableViewCell", bundle: nil)
            postsTableView.register(nib, forCellReuseIdentifier: "postNibCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(user?.name ?? "user")'s posts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingScreen))

        if let existingUser = user {
            NetworkManager().getPosts(byId: existingUser.id) { (posts) in
                DispatchQueue.main.async {
                    self.posts = posts
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
        self.present(navVC, animated: true)
    }
    
    func configure(_ user: User) {
        self.user = user
    }

}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "postNibCell", for: indexPath) as! TableViewCell
        cell.configure(post: posts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVCId") as! CommentsViewController
        vc.configure(posts[indexPath.row])
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
