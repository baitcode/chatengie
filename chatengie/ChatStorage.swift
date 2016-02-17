//
//  ChatStorage.swift
//  chatengie
//
//  Created by Ilia Batiy on 17/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation


protocol IChatStorage {
    func store(message: Message)
    func getChats() -> [Chat]
    func create(chat: Chat)
}


class ChatsStorage: IChatStorage {
    // TODO: Thats weird
    var chats: [Int:Chat] = [:]
    
    let lockQueue = dispatch_queue_create("ChatStorageLockQueue", nil)
    
    func getChats() -> [Chat] {
        return Array(self.chats.values) as [Chat]
    }
    
    func create(chat: Chat) {
        let chatHash = chat.hashValue
        
        dispatch_sync(lockQueue) {
            if self.chats[chatHash] == nil {
                self.chats[chatHash] = chat
            }
        }
    }
    
    func store(message: Message) {
        
        let chatHash = message.chatHashValue
        
        dispatch_sync(lockQueue) {
            if let chat = self.chats[chatHash] {
                chat.addMessage(message)
            } else {
                self.chats[chatHash] = Chat(firstMessage: message)
            }
            // TODO: Check for blocks
            NotificationManager.instance.notify(
                .ChatUpdated, data: [
                    "chat": self.chats[chatHash]!
                ], sender: self
            )
        }
    }
}

