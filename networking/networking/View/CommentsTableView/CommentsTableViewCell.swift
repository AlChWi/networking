//
//  CommentsTableViewCell.swift
//  networking
//
//  Created by Алексей Перов on 7/25/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    
    private var comment: Comment?
    
    func configure(comment: Comment) {
        self.comment = comment
        self.commentNameLabel.text = comment.name
        self.userEmailLabel.text = comment.email
        self.commentBodyLabel.text = comment.body
    }
}
