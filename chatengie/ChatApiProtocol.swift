//
//  protocols.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation
import PromiseKit


protocol IChatApiClient {
    func getMessages(forUser forUser: String, startingWith: Int) -> Promise<[String:AnyObject]>
    func sendMessage(from fromUser: String, to toUser: String, message: String) -> Promise<[String:AnyObject]>
}
