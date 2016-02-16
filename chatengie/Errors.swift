//
//  Errors.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//


enum ChatApiError: ErrorType {
    case BadRequest(message: String)
    case ConnectionError(message: String)
}
