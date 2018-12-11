//
//  DateExtension.swift
//  Post
//
//  Created by Steve Lederer on 12/10/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import Foundation

extension Date {
    
    var asString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
