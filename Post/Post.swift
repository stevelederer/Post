//
//  Post.swift
//  Post
//
//  Created by Steve Lederer on 12/10/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import Foundation

struct Post: Codable {
    // MARK: - Properties
    let text: String
    let timestamp: TimeInterval
    let username: String
    
    // MARK: - Memberwise initializer
    init(text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, username: String) {
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
    
    //computed property queryTimestamp
    var queryTimestamp: TimeInterval {
        return self.timestamp - 0.00001
    }
}
