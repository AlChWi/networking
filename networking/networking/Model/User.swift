//
//  User.swift
//  networking
//
//  Created by Алексей Перов on 7/25/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import Foundation

class User: Codable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
    
    init(name: String, username: String, email: String, address: Address, phone: String, website: String, company: Company) {
        self.id = 0
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
}
struct Address: Codable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo
}
struct Geo: Codable {
    var lat: String
    var lng: String
}
struct Company: Codable {
    var name: String
    var catchPhrase: String
    var bs: String
}
