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
                    print("error")
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
}
