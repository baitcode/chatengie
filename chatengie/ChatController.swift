//
//  ChatController
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import UIKit

class ChatController: UIViewController {
    
    @IBOutlet weak var barNavigationItem: UINavigationItem!
    var currentChat: Chat?
    var keyboradTracker: KeyboardTrackerBehavior!
    
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
    
}

