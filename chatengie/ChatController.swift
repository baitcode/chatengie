//
//  ChatController
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import UIKit
import SwiftSpinner

class ChatController: UIViewController, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barNavigationItem: UINavigationItem!
    @IBOutlet weak var fldMessage: UITextField!

    
    var observers: [AnyObject] = []
    var actions: Actions = Actions.sharedInstance
    var currentChat: Chat?
    var keyboradTracker: KeyboardTrackerBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboradTracker = KeyboardTrackerBehavior(
            self.view,
            elementsSettings: [
                self.fldMessage: 0
            ]
        )
        self.tableView.dataSource = self
        
        self.observers.append(NotificationManager.instance.listenFor(.ChatUpdated, triggers: {
            notification in
            if let chat = notification.userInfo!["chat"] as? Chat {
                if self.currentChat == chat {
                    self.tableView.reloadData()
                }
            }
        }))
    }
    
    @IBAction func textFieldDoneEditing(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = self.currentChat!.to.name
        self.keyboradTracker.startTracking()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.keyboradTracker.stopTracking()
        NotificationManager.instance.silence(self.observers)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let parts = self.currentChat?.splitByUser()
        return parts?.count ?? 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let parts = self.currentChat?.splitByUser()
        return parts![section].user.name
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("message", forIndexPath: indexPath)
        
        if indexPath.section % 2 == 1 {
            cell.textLabel?.textAlignment = .Right
            cell.textLabel?.textColor = UIColor.redColor()
        } else {
            cell.textLabel?.textAlignment = .Left
        }
        
        if let parts = self.currentChat?.splitByUser() {
            let message = parts[indexPath.section].messages[indexPath.row]
            cell.textLabel?.text = message.message
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let parts = self.currentChat?.splitByUser()
        return parts?[section].messages.count ?? 0
    }
    
    func initializeBeforeSegueWith(chat: Chat) {
        self.currentChat = chat
    }
 
    @IBAction func btnSendPressed(sender: AnyObject) {
        SwiftSpinner.show("Connecting to satellite")
        
        Actions.instance?.sendMessage(
            from: (self.currentChat?.from)!,
            to: (self.currentChat?.to)!,
            text: self.fldMessage.text!
        ).then({
            _ in
            self.fldMessage.resignFirstResponder()
            self.fldMessage.text = ""
        }).always({
            SwiftSpinner.hide()
        }).error({
            error in
            UAlerts.show(.Error, at: self, withText: getErrorMessage(from: error))
        })
    }
    
}

