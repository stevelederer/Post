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
    
    static func fetchPosts(reset: Bool = true, completion: @escaping() -> Void) {
        print("number of posts loaded is: \(posts.count)")
        // URL
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.queryTimestamp ?? Date().timeIntervalSince1970
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        let queryItems = urlParameters.compactMap({ URLQueryItem(name: $0.key, value: $0.value) } )
        guard let unwrappedURL = baseURL else { completion() ; return }
        var urlComponents = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { completion() ; return }
        let getterEndpoint = url.appendingPathExtension("json")
        
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
                let posts: [Post] = postsDictionary.compactMap({ $0.value })
                let sortedPosts = posts.sorted(by: { $0.timestamp > $1.timestamp })
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.append(contentsOf: sortedPosts)
                }
                completion()
            } catch {
                print("💩 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 💩")
                completion()
                return
            }
        }
        dataTask.resume()
        
    }
    
    static func addNewPostWith(username: String, text: String, completion: @escaping()->Void) {
        
        let post = Post(text: text, username: username)
        var postData: Data
        do {
            let encoder = JSONEncoder()
            postData = try encoder.encode(post)
        } catch {
            print("❌ There was an error in \(#function) :  \(error) \(error.localizedDescription)")
            completion()
            return
        }
        
        guard let unwrappedURL = baseURL else { return }
        let postEndpoint = unwrappedURL.appendingPathExtension("json")
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion()
                print(error.localizedDescription)
                return
            }
            guard let data = data, let dataAsString = String(data: data, encoding: .utf8) else {
                print("data was not posted")
                completion()
                return }
            print(dataAsString)
            
            fetchPosts {
                completion()
            }
        }
        dataTask.resume()
    }
}
