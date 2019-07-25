//
//  ViewController.swift
//  networking
//
//  Created by Алексей Перов on 7/22/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var networkManager = NetworkManager()
    private var posts: [Post] = []
    
    @IBOutlet weak var postsTableView: UITableView! {
        didSet {
            postsTableView.dataSource = self
            postsTableView.delegate = self
            let nib = UINib(nibName: "TableViewCell", bundle: nil)
            postsTableView.register(nib, forCellReuseIdentifier: "postNibCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func downloadPostsDidTap(_ sender: UIButton) {
        networkManager.getAllPosts() { posts in
            DispatchQueue.main.async {
                self.posts = posts
                self.postsTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "postNibCell", for: indexPath) as! TableViewCell
        cell.configure(post: posts[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var postId = posts[indexPath.row].id
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVCId") as! CommentsViewController
        vc.post = posts[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
//        networkManager.getCommentsForPost(postId) { comments in
//            
//        }
    }
    
}
