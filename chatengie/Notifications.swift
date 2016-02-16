//
//  Notifications.swift
//  qlean
//
//  Created by Ilia Batiy on 09/12/15.
//  Copyright © 2015 qlean. All rights reserved.
//

import Foundation


enum NotificationType: String {
    case UserLoggedIn = "UserLoggedIn"
    case ThreadListChanged = "ThreadListChanged"
    case ThreadSelectedByUser = "SelectedThreadChanged"
}


class NotificationManager {
    static var instance = NotificationManager()
    
    private var center = NSNotificationCenter.defaultCenter()
    private var sequence: Int64 = 0
    private var observers: [Int64: AnyObject] = [:]
    

    class Observer: NSObject {
        var handler: (NSNotification)->()!
        var id: Int64!
        
        init(id: Int64, handler: (NSNotification)->()) {
            self.id = id
            self.handler = handler
            super.init()
            NotificationManager.instance.observers[id] = self
        }
        
        func handle(notification: NSNotification) {
            self.handler(notification)
        }
    }

    func createObserver(handler: (NSNotification)->()) -> Observer {
        self.sequence += 1
        return Observer(id: self.sequence, handler: handler)
    }
    
    func listenFor(type: NotificationType, triggers: (NSNotification) -> ()) -> AnyObject {
        let observer = self.createObserver(triggers)
        self.center.addObserver(
            observer,
            selector: "handle:",
            name: type.rawValue,
            object: nil
        )
        return observer
    }
    
    func notify(type: NotificationType, data: [NSObject: AnyObject] = [:], sender: AnyObject? = nil) {
        self.center.postNotificationName(type.rawValue, object: sender, userInfo: data)
    }
    
    func silence(observer: AnyObject) {
        if let observer = observer as? Observer {
            self.center.removeObserver(observer)
            self.observers.removeValueForKey(observer.id)
        }
    }
    
    func silence(observers: [AnyObject]) {
        for (var i = 0; i < observers.count; i++) {
            self.silence(observers[i])
        }
    }
    
}