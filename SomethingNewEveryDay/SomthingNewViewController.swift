//
//  SomthingNewViewController.swift
//  SomethingNewEveryDay
//
//  Created by Ty Parker on 12/1/14.
//  Copyright (c) 2014 Ty Parker. All rights reserved.
//

import UIKit

class SomthingNewViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doText: UITextField!
    @IBOutlet weak var accomplishedBar: UISlider!
    @IBAction func submitButton(sender: UIButton) {
        //var user = PFUser.currentUser()
        var somethingNew = PFObject(className: "SomethingNew")
        somethingNew.setObject(self.textField.text, forKey: "learned")
        somethingNew.setObject(self.doText.text, forKey: "did")
        somethingNew.setObject(1, forKey: "show")
        somethingNew.setObject(self.accomplishedBar.value, forKey: "accomplished")
        somethingNew.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if true {
                NSLog("Object created with id: \(somethingNew.objectId)")
            } else {
                NSLog("%@", error)
            }

    }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
