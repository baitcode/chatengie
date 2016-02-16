//
//  EngieApiClient.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import PromiseKit
import Alamofire


class EngieApiClient: IChatApiClient {
    
    let endpoint: String!
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    private func call(path: String, parameters: [String:AnyObject]) -> Promise<[String:AnyObject]> {
        let request = Alamofire.request(.GET, "\(self.endpoint)\(path)", parameters: parameters)
        return Promise<[String:AnyObject]>(resolvers: {
            fulfill, reject in
            request.responseJSON(completionHandler: {
                response in
                switch response.result {
                case .Success:
                    let responseData = response.result.value as! [String:AnyObject]
                    
                    if let code = responseData["error"] as? Int {
                        if code == 200 {
                            fulfill(responseData)
                        }
                    }
                    var errorMessage = "Unknow error"
                    if let message = responseData["message"] as? String {
                        errorMessage = message
                    }
                    reject(ChatApiError.BadRequest(message: errorMessage))
                case .Failure(_):
                    reject(ChatApiError.ConnectionError(message: "Connection error"))
                }
            })
        })
    }
    
    func getMessages(from user: String, startingWith: Int = 0) -> Promise<[String:AnyObject]> {
        return self.call(
            "getMessages",
            parameters: [
                "user": user,
                "lastMessageReceived": startingWith
            ]
        )
    }
    
    func sendMessage(from fromUser: String, to toUser: String, message: String) -> Promise<[String:AnyObject]> {
        return self.call(
            "getMessages",
            parameters: [
                "fromUser": fromUser,
                "toUser": toUser,
                "message": message
            ]
        )
    }
}
