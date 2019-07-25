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
        }
    }
    
    private var post: Post?
    private var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Comments"
        
        if let existingPost = post {
            NetworkManager().getCommentsForPost(existingPost.id) { (comments) in
                self.comments = comments
                DispatchQueue.main.async {
                    self.commentsTableView.reloadData()
                }
            }
        }
    }
    
    func configure(_ post: Post) {
        self.post = post
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
    
    
}
