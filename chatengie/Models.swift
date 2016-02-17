//
//  models.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation
import ModelRocket
import PromiseKit





//class ChatManager {
//
//    func loginAs(userName: String) {
//        
//    }
//    
//    func addThread(with userName: String) {
//        
//    }
//    
//}
//
//class User: Model, JSONTransformable {
//    let name = Property<String>(key: "name")
//    
//    convenience init(name: String) {
//        self.init()
//        self.name.value = name
//    }
//}
//
//
//class ThreadManager {
//    private var api: IChatApiClient
//    
//    var lastSeenMessages = 0
//    
//    init(api: IChatApiClient) {
//        self.api = api
//    }
//    
//    func getForUser(user: User) -> Promise<[Message]> {
//        return self.api.getMessages(from: user.name.value!, startingWith: self.lastSeenMessages).then({
//            data in
//            let messageDataList = data["data"] as! [[String:AnyObject]]
//            let messages = messageDataList.map({ data in Message(json: JSON(data)) })
//            return Promise(messages)
//        })
//    }
//}
//
//
//class Message: Model, JSONTransformable {
//    let text = Property<String>(key: "message")
//    
//    convenience init(text: String) {
//        self.init()
//        self.text.value = text
//    }
//}
//
//class Thread: Model {
//    let with = Property<User>(key: "user")
//    let messages = PropertyArray<Message>(key: "data")
//    
//    func getName() -> String? {
//        return self.with.value?.name.value
//    }
//    
//    convenience init(with user: User, messages: [Message] = []) {
//        self.init()
//        self.with.value = user
//        self.messages.values = messages
//    }
//}
