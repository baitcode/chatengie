//
//  Chat.swift
//  chatengie
//
//  Created by Ilia Batiy on 17/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation


struct ChatPart {
    var user: User
    var messages: [Message]
}


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
    
    func splitByUser() -> [ChatPart] {
        
        var chatParts: [ChatPart] = []
        
        var currentChatPart: ChatPart? = nil
        
        let sortedMessages = self.messages//.sort({ a, b in a.id < b.id })
        
        for var message in sortedMessages {
            if currentChatPart == nil {
                currentChatPart = ChatPart(user: message.from, messages: [message])
            } else {
                if currentChatPart!.user != message.from {
                    chatParts.append(currentChatPart!)
                    currentChatPart = ChatPart(user: message.from, messages: [message])
                } else {
                    currentChatPart?.messages.append(message)
                }
            }
        }
        if let part = currentChatPart {
            chatParts.append(part)
        }
    
        return chatParts
    }
    
}

func ==(lhs: Chat, rhs: Chat) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

