//
//  NetworkManager.swift
//  networking
//
//  Created by Алексей Перов on 7/22/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import Foundation

class NetworkManager {
    func getAllPosts(_ completionHandler: @escaping ([Post]) -> Void) {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    
                } else {
                    if let resp = response as? HTTPURLResponse, resp.statusCode == 200, let responseData = data {
                        
                        print(responseData)
                        let posts = try? JSONDecoder().decode([Post].self, from: responseData)
                        
                        completionHandler(posts ?? [])
                    }
                }
                }.resume()
        }
    }
    func getCommentsForPost(_ postId: Int, _ completionHandler: @escaping ([Comment]) -> Void) {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(String(postId))") {
            print(url)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                } else {
                    if let resp = response as? HTTPURLResponse, (200..<300).contains(resp.statusCode), let responseData = data {
                        
                        print(responseData)
                        let comments = try? JSONDecoder().decode([Comment].self, from: responseData)
                        
                        completionHandler(comments ?? [])
                    } else {
                        print((200..<300).contains((response as! HTTPURLResponse).statusCode))
                    }
                }
            }.resume()
        }
    }
    func getAllUsers(_ completionHandler: @escaping ([User]) -> Void) {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/users") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                } else {
                    if let resp = response as? HTTPURLResponse, (200..<300).contains(resp.statusCode), let responseData = data {
                        print(responseData)
                        let users = try? JSONDecoder().decode([User].self, from: responseData)
                        completionHandler(users ?? [])
                    }
                }
                
            }.resume()
        }
    }
}
