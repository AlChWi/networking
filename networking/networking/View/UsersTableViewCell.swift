//
//  UsersTableViewCell.swift
//  networking
//
//  Created by Алексей Перов on 7/25/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    private var user: User?
    
    func configure(_ user: User) {
        self.user = user
        self.userNameLabel.text = user.name
        self.userEmailLabel.text = user.email
        self.accessoryType = .disclosureIndicator
    }
}
