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

class Actions {
    
    static let APP_MODE: AppMode = .Debug
    static var instance: Actions? = Actions()
    
    var api = EngieApiClient(endpoint: "http://api.beta.engie.co.il/test/chat/")
    
    var currentUser: User?
    
    var threads: [Thread] = []
    var threadIndex: [String:Thread] = [:]
    
    func logIn(name: String) -> Promise<User> {
        return Promise<User>(resolvers: {
            fulfill, reject in
            let cleanName = name.trim()
            
            if cleanName.isEmpty {
                return reject(ActionError("Username can not be empty"))
            }

            self.currentUser = User(name: cleanName)
            
            NotificationManager.instance.notify(.UserLoggedIn)
            fulfill(self.currentUser!)
        })
    }
    
    func startThread(with name: String) -> Promise<Thread> {
        return Promise<Thread>(resolvers: {
            fulfill, reject in

            let cleanName = name.trim()
            
            if cleanName.isEmpty {
                return reject(ActionError("Username can not be empty"))
            }
            
            if let _ = self.threadIndex[cleanName] {
                return reject(ActionError("Thread already exists"))
            }
            
            self.api.getMessages(from: name).then({
                data in
                print(data)
            }).error({
                error in
                switch (error) {
                case ChatApiError.BadRequest(let message):
                    // Notify developers.
                    reject(ActionError("There might be a problem with data you've sent."))
                case ChatApiError.ConnectionError(let message):
                    reject(ActionError("Network unreachable, please check your connection and try again."))
                default:
                    // Notify developers.
                    reject(ActionError("Client is out of order."))
                }
            })
            
            let thread = Thread(with: User(name: cleanName), messages: [])
            self.threadIndex[cleanName] = thread
            self.threads.append(thread)
            
            NotificationManager.instance.notify(.ThreadListChanged)
            fulfill(thread)
        })
    }
        
    class var sharedInstance: Actions {
        if Actions.instance == nil {
            Actions.instance = Actions()
        }
        return Actions.instance!
    }
    
    func dispose() {
        Actions.instance = nil
    }
}