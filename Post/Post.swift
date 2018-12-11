//
//  Post.swift
//  Post
//
//  Created by Steve Lederer on 12/10/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import Foundation

struct Post: Codable {
    let text: String
    let timestamp: TimeInterval
    let username: String
    
    init(text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, username: String) {
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
}
