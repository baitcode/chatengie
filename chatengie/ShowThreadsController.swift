//
//  ShowThreadsController.swift
//  chatengie
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import UIKit


class ShowThreadsController: UITableViewController {
    
    var observers: [AnyObject] = []
    var actions = Actions.sharedInstance
    var selectedThread: Thread?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.observers.append(NotificationManager.instance.listenFor(.ThreadListChanged, triggers: {
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
        return self.actions.threads.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thread = self.actions.threads[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ThreadCell", forIndexPath: indexPath)
        cell.textLabel?.text = thread.getName()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NotificationManager.instance.notify(
            .ThreadSelectedByUser,
            data: [
                "thread": self.actions.threads[indexPath.row]
            ]
        )
        
    }

}