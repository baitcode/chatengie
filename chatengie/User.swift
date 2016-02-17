//
//  User.swift
//  chatengie
//
//  Created by Ilia Batiy on 17/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation


class User: Hashable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    var hashValue: Int {
        get {
            return self.name.hashValue
        }
    }
}


func ==(lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
