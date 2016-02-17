//
//  ChatController
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import UIKit
import SwiftSpinner

class ChatController: UIViewController {
    
    @IBOutlet weak var barNavigationItem: UINavigationItem!
    @IBOutlet weak var fldMessage: UITextView!
    
    var currentChat: Chat?
    var keyboradTracker: KeyboardTrackerBehavior!
    var actions: Actions = Actions.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboradTracker = KeyboardTrackerBehavior(
            self.view,
            elementsSettings: [:]
        )
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
        }).always({
            SwiftSpinner.hide()
        }).error({
            error in
            UAlerts.show(.Error, at: self, withText: getErrorMessage(from: error))
        })
    }
    
}

