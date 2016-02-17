//
//  ChatsListController
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import UIKit


class ChatsListController: UITableViewController {
    
    var observers: [AnyObject] = []
    var actions = Actions.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.observers.append(NotificationManager.instance.listenFor(.ChatListChanged, triggers: {
            _ in
            self.refresh()
        }))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationManager.instance.silence(self.observers)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actions.chatStorage.getChats().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chat = self.actions.chatStorage.getChats()[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath)
        cell.textLabel?.text = chat.to.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let chat = self.actions.chatStorage.getChats()[indexPath.row]
        NotificationManager.instance.notify(
            .ChatSelectedByUser,
            data: [
                "chat": chat
            ]
        )
        
    }

}