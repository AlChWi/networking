//
//  post.swift
//  networking
//
//  Created by Алексей Перов on 7/22/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import Foundation

class Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
