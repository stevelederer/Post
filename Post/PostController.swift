//
//  PostController.swift
//  Post
//
//  Created by Steve Lederer on 12/10/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class PostController {
    
    // MARK: - Properties
    static let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    static var posts: [Post] = []
    
    static func fetchPosts(completion: @escaping() -> Void) {
        // URL
        guard let baseURL = baseURL else { completion() ; return }
        let getterEndpoint = baseURL.appendingPathExtension("json")
        
        print("📡📡📡 \(getterEndpoint.absoluteString) 📡📡📡")
        
        // Request
        var request = URLRequest(url: getterEndpoint)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // Data task and RESUME
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            }
            
            guard let data = data else { completion(); return}
            
            let decoder = JSONDecoder()
            
            do {
                let postsDictionary = try decoder.decode([String:Post].self, from: data)
                var posts: [Post] = postsDictionary.compactMap({ $0.value })
                posts.sort(by: { $0.timestamp > $1.timestamp })
                self.posts = posts
                completion()
            } catch {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion()
                return
            }
        }
        dataTask.resume()
        
    }
}
