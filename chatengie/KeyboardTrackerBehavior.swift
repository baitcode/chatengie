//
//  ViewKeyboardTracker.swift
//  qlean
//
//  Created by Ilia Batiy on 30/10/15.
//  Copyright (c) 2015 qlean. All rights reserved.
//

import Foundation
import UIKit


class KeyboardTrackerBehavior: NSObject {
    private var deviceOffset: CGFloat = 0
    
    static var isKeyboardVisible: Bool = false
    static var lastNotification: NSNotification? = nil
    
    private var elementsSettings: [UIResponder:CGFloat?]
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    private var viewToMove: UIView
    private var isTrackingStarted = false
    
    private var initialViewHeight: CGFloat!
    private var initialViewY: CGFloat!
    private var tapRecognizer: UIGestureRecognizer!
    
    var keyboardWillShowCallback: () -> Void = {
        () -> Void in
    }

    var keyboardDidShowCallback: () -> Void = {
        () -> Void in
    }
    
    var keyboardWillHideCallback: () -> Void = {
        () -> Void in
    }
    
    private var notificationLinks: [Selector:String] = [
        Selector("keyboardWillShow:"): UIKeyboardWillShowNotification,
        Selector("keyboardDidShow:"): UIKeyboardDidShowNotification,
        Selector("keyboardWillHide:"): UIKeyboardWillHideNotification,
        Selector("keyboardDidHide:"): UIKeyboardDidHideNotification,
    ]
    
    func dismissKeyboard() {
        getResponder()?.resignFirstResponder()
    }
    
    init(_ viewToMove: UIView, elementsSettings: [UIResponder:CGFloat?]) {
        self.elementsSettings = elementsSettings
        self.viewToMove = viewToMove
        super.init()
        self.initialViewHeight = self.viewToMove.frame.height
        self.initialViewY = self.viewToMove.frame.origin.y
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        for (_, notification) in self.notificationLinks {
            self.notificationCenter.removeObserver(
                self,
                name: notification,
                object: nil
            )
        }
        viewToMove.removeGestureRecognizer(tapRecognizer)
    }
    
    private func subscribeToKeyboardNotifications() {
        for (selector, notification) in self.notificationLinks {
            self.notificationCenter.addObserver(
                self,
                selector: selector,
                name: notification,
                object: nil
            )
        }
        viewToMove.addGestureRecognizer(tapRecognizer)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func getKeyboardAnimationDuration(notification: NSNotification) -> Double {
        let userInfo = notification.userInfo
        let keyboardAnimationDuration = userInfo![UIKeyboardAnimationDurationUserInfoKey] // of CGRect
        return keyboardAnimationDuration?.doubleValue ?? 0
    }

    func getKeyboardAnimationCurve(notification: NSNotification) -> Int? {
        let userInfo = notification.userInfo
        let keyboardAnimationCurve = userInfo![UIKeyboardAnimationCurveUserInfoKey] // of CGRect
        return keyboardAnimationCurve?.integerValue
    }
    
    func getResponder() -> UIResponder? {
        for (element, _) in self.elementsSettings {
            if element.isFirstResponder() {
                return element
            }
        }
        return nil
    }
    
    func shrinkToKeyboardSize(notification: NSNotification, animated: Bool = true) {
        var options: UIViewAnimationOptions = [.BeginFromCurrentState]
        if let curve = self.getKeyboardAnimationCurve(notification) {
            options = options.union([UIViewAnimationOptions.init(rawValue: UInt(curve))])
        }
        let duration = self.getKeyboardAnimationDuration(notification)
        let keyboardHeight = self.getKeyboardHeight(notification)
        let width = self.viewToMove.frame.width
        
        UIView.animateWithDuration(
            animated ? NSTimeInterval(duration): 0,
            delay: NSTimeInterval(0),
            options: options,
            animations: { () -> Void in
                let shrinkHeight = self.initialViewHeight - keyboardHeight
                self.viewToMove.frame = CGRectMake(0, 0, width, shrinkHeight)
            },
            completion: {
                _ in
                self.viewToMove.layoutIfNeeded()
            }
        )
    }
    
    func expandToFullScreen(notification: NSNotification, animated: Bool = true) {
        var options: UIViewAnimationOptions = [.BeginFromCurrentState]
        if let curve = self.getKeyboardAnimationCurve(notification) {
            options = options.union([UIViewAnimationOptions.init(rawValue: UInt(curve))])
        }
        let duration = self.getKeyboardAnimationDuration(notification)

        UIView.animateWithDuration(
            animated ? NSTimeInterval(duration): 0,
            delay: NSTimeInterval(0),
            options: options,
            animations: { () -> Void in
                self.viewToMove.frame = CGRectMake(0, 0, self.viewToMove.frame.width, self.initialViewHeight);
                self.viewToMove.frame.origin.y = self.initialViewY
            },
            completion: nil
        )
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.keyboardWillShowCallback()
        self.shrinkToKeyboardSize(notification)
    }
    
    func adjustViewFor(element: UIResponder){
        let offset = (self.elementsSettings[element] ?? 0)!

        UIView.animateWithDuration(
            NSTimeInterval(0.2),
            delay: NSTimeInterval(0),
            options: [UIViewAnimationOptions.BeginFromCurrentState],
            animations: { () -> Void in
                let relativeOffset = offset + self.deviceOffset + self.viewToMove.frame.origin.y
                self.viewToMove.frame.origin.y -= relativeOffset
            },
            completion: { (complete: Bool) -> Void in
            }
        )
    }

    func findInputAndSlideToIt() {
        for (element, _) in self.elementsSettings {
            if element.isFirstResponder() {
                self.adjustViewFor(element)
            }
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        self.shrinkToKeyboardSize(notification, animated: true)
        self.keyboardDidShowCallback()
        KeyboardTrackerBehavior.isKeyboardVisible = true
        KeyboardTrackerBehavior.lastNotification = notification
        
        self.findInputAndSlideToIt()
    }
    
    func refresh() {
        if KeyboardTrackerBehavior.isKeyboardVisible {
            self.shrinkToKeyboardSize(
                KeyboardTrackerBehavior.lastNotification!,
                animated: true
            )
            self.findInputAndSlideToIt()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.keyboardWillHideCallback()
        self.expandToFullScreen(notification)
    }
    
    func keyboardDidHide(notification: NSNotification) {
        KeyboardTrackerBehavior.isKeyboardVisible = false
    }
    
    func startTracking() {
        if isTrackingStarted {
            return
        }
        self.subscribeToKeyboardNotifications()
        isTrackingStarted = true
    }
    
    func stopTracking() {
        self.unsubscribeFromKeyboardNotifications()
        isTrackingStarted = false
    }
}