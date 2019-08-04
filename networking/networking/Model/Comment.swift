//
//  Comment.swift
//  networking
//
//  Created by Алексей Перов on 7/25/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import Foundation

class Comment: Codable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
    
    init(postId: Int, name: String, email: String, body: String) {
        self.id = 0
        self.postId = postId
        self.name = name
        self.email = email
        self.body = body
    }
}
