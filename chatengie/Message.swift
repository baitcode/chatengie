//
//  Message.swift
//  chatengie
//
//  Created by Ilia Batiy on 17/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation


class Message {
    var id: Int?
    var from: User
    var to: User
    var message: String

    init(id: Int? = nil, to: User, from: User, message: String){
        self.id = id
        self.from = from
        self.to = to
        self.message = message
    }
    
    var chatHashValue: Int {
        get {
            return [to.name, from.name]
                .sort()
                .joinWithSeparator("__")
                .hashValue
        }
    }
}
