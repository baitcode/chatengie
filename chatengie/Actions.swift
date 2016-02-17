//
//  AppLogic.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit


class ActionError: ErrorType {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}


enum AppMode: String {
    case Debug = "DEBUG"
    case Prod = "PROD"
}


let config = [
    "endpoint": "http://api.beta.engie.co.il/test/chat/"
]


class Actions {
    
    static let APP_MODE: AppMode = .Debug
    static var instance: Actions?
    
    var api: IChatApiClient!

    var currentUser: User?
    var chatStorage: IChatStorage
    var messageLoader: IMessageLoader
    
    init(config: [String:AnyObject]){
        self.api = EngieApiClient(endpoint: config["endpoint"] as! String)
        self.chatStorage = ChatsStorage()
        self.messageLoader = MessageLoader(api: self.api, chatsStorage: self.chatStorage)
    }
    
    func logIn(name: String) -> Promise<User> {
        return Promise<User>(resolvers: {
            fulfill, reject in
            let cleanName = name.trim()
            
            if cleanName.isEmpty {
                return reject(ActionError("Username can not be empty"))
            }

            self.messageLoader.registerUser(User(name: cleanName))

            self.currentUser = User(name: cleanName)
            
            NotificationManager.instance.notify(.UserLoggedIn)
            fulfill(self.currentUser!)
        })
    }
    
    func startChat(with name: String) -> Promise<AnyObject?> {
        return Promise<User>(resolvers: {
            fulfill, reject in

            let cleanName = name.trim()
    
            if cleanName.isEmpty {
                return reject(ActionError("Username can not be empty"))
            }

            let user = User(name: cleanName)
            if !self.messageLoader.registerUser(user) {
                return reject(ActionError("Thread already exists"))
            }
            
            self.chatStorage.create(Chat(from: currentUser!, to: user))
            NotificationManager.instance.notify(.ChatListChanged)
            fulfill(user)
        }).then({
            user in
            return self.messageLoader.load(forUser: user)
        })
    }
    
    func sendMessage(from from: User, to: User, text: String) -> Promise<Message> {
        return self.api.sendMessage(from: from.name, to: to.name, message: text).then({
            data in
            return Promise(Message(to: to, from: from, message: text))
        })
    }
        
    class var sharedInstance: Actions {
        if Actions.instance == nil {
            Actions.instance = Actions(config: config)
        }
        return Actions.instance!
    }
    
    func dispose() {
        Actions.instance = nil
    }
}