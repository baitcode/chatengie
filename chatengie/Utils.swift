//
//  Common.swift
//  chatengie
//
//  Created by Ilia Batiy on 17/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation


func getErrorMessage(from error: ErrorType) -> String {
    
    switch (error) {
    case let error as ActionError:
        return error.message
    case ChatApiError.BadRequest(let message):
        // NOTIFIY DEVS
        return "We have some problems with your data. \(message)."
    case ChatApiError.ConnectionError(_):
        return "Internet is inaccessible. Please check internet connection."
    default:
        // NOTIFIY DEVS
        return "Something spooky going on."
    }
}