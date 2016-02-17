//
//  Chat.swift
//  chatengie
//
//  Created by Ilia Batiy on 17/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation

class Chat: Hashable {
    var to: User
    var from: User
    var messages: [Message] = []
    
    init(from: User, to: User){
        self.from = from
        self.to = to
    }
    
    convenience init(firstMessage message: Message) {
        self.init(from: message.from, to: message.to)
        self.messages.append(message)
    }
    
    var hashValue: Int {
        get {
            return [to.name, from.name]
                .sort()
                .joinWithSeparator("__")
                .hashValue
        }
    }
    
    func addMessage(message: Message) {
        self.messages.append(message)
    }
    
}

func ==(lhs: Chat, rhs: Chat) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

