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
    private var posts: [Post] = [] {
        didSet {
            postsTableView.reloadData()
        }
    }
    
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


    @IBAction func createPostAction(_ sender: Any) {
        let post = Post(userId: 1, title: "title", body: "body")
        networkManager.postCreatePost(post) { (serverPost) in
            post.id = serverPost.id
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Great!", message: "Your post has been created", preferredStyle: .alert)
                
                self.present(alert, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    alert.dismiss(animated: true)
                }
            }
        }
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVCId") as! CommentsViewController
        vc.configure(posts[indexPath.row])
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
