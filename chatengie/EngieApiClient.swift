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
        let fullPath = "\(self.endpoint)\(path)"
        let request = Alamofire.request(.GET, fullPath, parameters: parameters)
        
        return Promise<[String:AnyObject]>(resolvers: {
            fulfill, reject in
            request.responseJSON(completionHandler: {
                response in
                
                print("REQUEST - \(response.response?.statusCode) \(response.request?.URLString)")
                
                switch response.result {
                case .Success(let JSON):
                    let responseData = JSON as! [String:AnyObject]
                    print(responseData)
                    if let code = responseData["code"] as? Int {
                        if code == 200 {
                            return fulfill(responseData)
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
    
    func getMessages(forUser forUser: String, startingWith: Int = 0) -> Promise<[String:AnyObject]> {
        return self.call(
            "getMessages",
            parameters: [
                "user": forUser,
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
