//
//  UsersTableViewCell.swift
//  networking
//
//  Created by Алексей Перов on 7/25/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfilePhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userCompanyNameLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    private var user: User?
    
    func configure(_ user: User) {
        shadowView.layer.backgroundColor = UIColor.clear.cgColor
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 10
        userProfilePhotoImageView.layer.backgroundColor = UIColor.clear.cgColor
        userProfilePhotoImageView.layer.shadowColor = UIColor.black.cgColor
        userProfilePhotoImageView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        userProfilePhotoImageView.layer.shadowOpacity = 0.2
        userProfilePhotoImageView.layer.shadowRadius = 5
        
        containerView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        containerView.layer.cornerRadius = 15.0
        containerView.layer.masksToBounds = true
        
        self.user = user
        self.selectionStyle = .none
        self.userNameLabel.text = user.name
        self.userUsernameLabel.text = user.username
        self.userPhoneLabel.text = user.phone
        self.userEmailLabel.text = user.email
        self.userCompanyNameLabel.text = user.company.name
        self.userWebsiteLabel.text = user.website
    }
}

extension UsersTableViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: animationOptions, animations: {
                    self.transform = .init(scaleX: 0.95, y: 0.95)
            }, completion: completion)
        } else {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: animationOptions, animations: {
                    self.transform = .identity
            }, completion: completion)
        }
    }
}
