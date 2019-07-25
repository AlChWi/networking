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
}
