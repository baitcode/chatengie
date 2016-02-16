//
//  models.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation
import ModelRocket

class ChatManager {

    func loginAs(userName: String) {
        
    }
    
    func addThread(with userName: String) {
        
    }
    
}

class User: Model, JSONTransformable {
    let name = Property<String>(key: "name")
}


class Message: Model, JSONTransformable {
    let text = Property<String>(key: "message")
}

class Thread: Model {
    let with = Property<User>(key: "user")
    let messages = PropertyArray<Message>(key: "message")
    
    func post(message: String) {
        
    }
}


//class ApplicationState {
//    let currentUser: User?
//    let openThreads: [Thread]?

    
//}