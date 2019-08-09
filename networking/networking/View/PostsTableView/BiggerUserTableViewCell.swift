//
//  BiggerUserTableViewCell.swift
//  networking
//
//  Created by Alex P on 07/08/2019.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class BiggerUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userStreetLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    @IBOutlet weak var userCompanyNameLabel: UILabel!
    @IBOutlet weak var userCompanyCatchPhraseLabel: UILabel!
    @IBOutlet weak var userCompanyBSLabel: UILabel!
    
    private var user: User?

    func configure(_ user: User) {
        self.user = user
        self.selectionStyle = .none
        self.userNameLabel.layer.cornerRadius = 8
        self.userNameLabel.layer.masksToBounds = true
        self.userCompanyNameLabel.layer.cornerRadius = 8
        self.userCompanyNameLabel.backgroundColor = Constants.UIConstants.appTintColor
        self.userCompanyNameLabel.layer.masksToBounds = true
        self.userNameLabel.text = user.name
        self.userUsernameLabel.text = user.username
        self.userEmailLabel.text = user.email
        self.userCityLabel.text = user.address.city
        self.userStreetLabel.text = user.address.street
        self.userPhoneLabel.text = user.phone
        self.userWebsiteLabel.text = user.website
        self.userCompanyNameLabel.text = user.company.name
        self.userCompanyCatchPhraseLabel.text = user.company.catchPhrase
        self.userCompanyBSLabel.text = user.company.bs
    }
}
