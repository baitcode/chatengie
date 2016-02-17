//
//  UserMessageStreams.swift
//  chatengie
//
//  Created by Ilia Batiy on 17/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation
import PromiseKit


protocol IMessageLoader {
    func registerUser(user: User) -> Bool
    func load() -> [Promise<Bool>]
    func load(forUser user: User) -> Promise<Bool>
}


class MessageLoader: IMessageLoader {
    var api: IChatApiClient
    var users = Set<User>()
    var usersLastSeenIds = [User:Int]()
    var chatsStorage: IChatStorage
    
    init(api: IChatApiClient, chatsStorage: IChatStorage) {
        self.api = api
        self.chatsStorage = chatsStorage
    }
    
    func registerUser(user: User) -> Bool {
        // Checks if user wasn't registered for message fetching, and adds him to the set
        
        // If user already registered does nothing and returns false
        if self.users.contains(user) {
            return false
        }
        self.users.insert(user)
        self.usersLastSeenIds[user] = 0
        return true
    }
    
    func load(forUser user: User) -> Promise<Bool> {
        let lastSeenId = self.usersLastSeenIds[user] as Int!
        
        return self.api.getMessages(forUser: user.name, startingWith: lastSeenId).then({
            data in
            
            var newLastSeenId = lastSeenId
            
            for messageData in data["data"] as! [[String:AnyObject]] {
                let fromName = messageData["fromUser"] as! String
                let text = messageData["message"] as! String
                let id = messageData["id"] as! Int
                
                let message = Message(
                    id: id,
                    to: user,
                    from: User(name: fromName),
                    message: text
                )
                if newLastSeenId < id {
                    newLastSeenId = id
                }
                
                if self.users.contains(message.to) || self.users.contains(message.from) {
                    self.chatsStorage.store(message)
                }
            }
            self.usersLastSeenIds[user] = newLastSeenId
            return Promise(newLastSeenId != lastSeenId)
        })
    }
    
    func load() -> [Promise<Bool>] {
        return self.users.map({
            user in self.load(forUser: user)
        })
    }
}