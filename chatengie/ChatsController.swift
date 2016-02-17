//
//  MainChatsController
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import UIKit
import SwiftSpinner
import PromiseKit

class ChatsController: UIViewController {
    
    @IBOutlet weak var fldFriendName: UITextField!
    let actions = Actions.sharedInstance
    var observers: [AnyObject] = []
    var selectedChat: Chat?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if Actions.APP_MODE == .Debug {
            self.fldFriendName.text = "yaron"
        }
        
        self.observers.append(NotificationManager.instance.listenFor(.ChatSelectedByUser, triggers: {
            notification in
            self.onChatSelectedByUser(notification.userInfo!["chat"] as! Chat)
        }))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationManager.instance.silence(self.observers)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChat" {
            let controller = segue.destinationViewController as! ChatController
            controller.initializeBeforeSegueWith(self.selectedChat!)
        }
    }

    @IBAction func textFieldDoneEditing(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func btnAddFriendPressed(sender: AnyObject) {
        SwiftSpinner.show("Ur friends are belong to us")
        
        self.actions.startChat(with: fldFriendName.text!).then({
            _ in
        }).always({
            SwiftSpinner.hide()
        }).error({
            error in
            UAlerts.show(.Error, at: self, withText: getErrorMessage(from: error))
        })
    }
    
    func onChatSelectedByUser(chat: Chat) {
        self.selectedChat = chat
        self.performSegueWithIdentifier("showChat", sender: self)
    }
    
    
}