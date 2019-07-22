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
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func downloadPostsDidTap(_ sender: UIButton) {
        networkManager.getAllPosts() { posts in
            DispatchQueue.main.async {
                self.titleLabel.text = "post have been downloaded"
            }
        }
    }
}

