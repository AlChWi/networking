//
//  NetworkManager.swift
//  networking
//
//  Created by Алексей Перов on 7/22/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import Foundation

class NetworkManager {
    
    enum HTTPMethods: String {
        case POST
        case PUT
        case GET
        case DELETE
    }
    
    enum APIs: String {
        case posts
        case users
        case comments
    }
    
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    
    func getAllPosts(_ completionHandler: @escaping ([Post]) -> Void) {
        if let url = URL(string: baseURL + APIs.posts.rawValue) {
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
    
    func postCreatePost(_ post: Post, completionHandler: @escaping (Post) -> Void) {
        guard let url = URL(string: baseURL + APIs.posts.rawValue), let data = try? JSONEncoder().encode(post)
            else { return }
        let request = MutableURLRequest(url: url)
        request.httpMethod = HTTPMethods.POST.rawValue
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print(error)
            } else if let resp = response as? HTTPURLResponse, resp.statusCode == 201, let responseData = data {
                let json = try? JSONSerialization.jsonObject(with: responseData)
                print(json)
                if let responsePost = try? JSONDecoder().decode(Post.self, from: responseData) {
                    completionHandler(responsePost)
                }
            }
            
        }.resume()
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
