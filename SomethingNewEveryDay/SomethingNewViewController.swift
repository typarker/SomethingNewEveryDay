//
//  SomethingNewViewController.swift
//  SomethingNewEveryDay
//
//  Created by Ty Parker on 11/28/14.
//  Copyright (c) 2014 Ty Parker. All rights reserved.
//

import UIKit


class SomethingNewViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!

    @IBAction func button(sender: AnyObject) {
        
        //var user = PFUser.currentUser()
        var somethingNew = PFObject(className: "SomethingNew")
        somethingNew.setObject(self.textField.text, forKey: "learned")
        somethingNew.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if true {
                NSLog("Object created with id: \(somethingNew.objectId)")
            } else {
                NSLog("%@", error)
            }
    }
    
}
}
