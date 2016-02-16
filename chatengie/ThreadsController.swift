//
//  ThreadsController.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import UIKit
import SwiftSpinner
import PromiseKit

class ThreadsController: UIViewController {
    
    @IBOutlet weak var fldFriendName: UITextField!
    let actions = Actions.sharedInstance
    var observers: [AnyObject] = []
    var selectedThread: Thread?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Actions.APP_MODE == .Debug {
            self.fldFriendName.text = "yaron"
        }
        
        self.observers.append(NotificationManager.instance.listenFor(.ThreadSelectedByUser, triggers: {
            notification in
            self.onThreadSelectedByUser(notification.userInfo!["thread"] as! Thread)
        }))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationManager.instance.silence(self.observers)
    }
    
    @IBAction func btnAddFriendPressed(sender: AnyObject) {
        SwiftSpinner.show("Ur friends are belong to us")
        
        self.actions.startThread(with: fldFriendName.text!).then({
            _ in
        }).always({
            SwiftSpinner.hide()
        }).error({
            error in
            let actionError = error as! ActionError
            UAlerts.show(.Error, at: self, withText: actionError.message)
        })
    }
    
    func onThreadSelectedByUser(thread: Thread) {
        self.selectedThread = thread
        self.performSegueWithIdentifier("showChat", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChat" {
            let controller = segue.destinationViewController as! ChatController
            controller.initializeBeforeSegueWith(self.selectedThread!)
        }
    }
    
}