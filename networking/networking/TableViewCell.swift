//
//  TableViewCell.swift
//  networking
//
//  Created by Алексей Перов on 7/25/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    private var post: Post?
    
    func configure(post: Post) {
        self.post = post
        postTitleLabel.text = post.title
        postDescriptionLabel.text = post.body
        self.accessoryType = .disclosureIndicator
    }
}
