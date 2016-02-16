//
//  Alerts.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 17/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit

enum AlertType: String {
    case Error = "Error"
}

class UAlerts {
    
    class func show(type: AlertType, at: UIViewController, withText text: String, andTitle title: String? = nil) {
        let controller = UIAlertController(
            title: title ?? "Error",
            message: text,
            preferredStyle: .Alert
        )
        controller.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        at.presentViewController(controller, animated: true, completion: nil)
    }
    
}