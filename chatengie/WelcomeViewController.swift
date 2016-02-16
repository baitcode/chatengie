//
//  WelcomeViewController.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner


class WelcomeViewController: UIViewController {

    @IBOutlet weak var fldUserName: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var actions = Actions.sharedInstance
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Actions.APP_MODE == .Debug {
            self.fldUserName.text = "baitcode"
        }
    }
    
    
    @IBAction func btnLoginPressed(sender: UIButton) {
        SwiftSpinner.show("selfdestruction in 5")

        self.actions.logIn(fldUserName.text!).then({
            _ in
            self.performSegueWithIdentifier("logIn", sender: sender)
        }).always({
            SwiftSpinner.hide()
        }).error({
            error in
            let actionError = error as! ActionError
            UAlerts.show(.Error, at: self, withText: actionError.message)
        })
    }
    
}

