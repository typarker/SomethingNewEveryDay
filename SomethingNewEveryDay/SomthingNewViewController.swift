//
//  SomthingNewViewController.swift
//  SomethingNewEveryDay
//
//  Created by Ty Parker on 12/1/14.
//  Copyright (c) 2014 Ty Parker. All rights reserved.
//

import UIKit
import QuartzCore

class SomthingNewViewController: UIViewController, UITextViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var youDid: UITextView! = UITextView()
    //@IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doText: UITextView!
    @IBOutlet weak var textField: UITextView!
    
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertActionStyle.Default, handler: { action in self.logout()}))

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:  nil))
            presentViewController(alert, animated: true, completion: nil)
    }
    
        func logout() {
            // Log Out User
        PFUser.logOut()
        // Show the signup or login screen
        var logInController = PFLogInViewController()
        var signUpController = PFSignUpViewController()
        
        //let users sign up with email only
        
        
//        logInController.signUpController = signUpController
//        
//        logInController.signUpController.delegate = self
        logInController.delegate = self
//        logInController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.SignUpButton | PFLogInFields.LogInButton | PFLogInFields.PasswordForgotten
//        
//        logInController.signUpController.fields = PFSignUpFields.UsernameAndPassword
//            | PFSignUpFields.SignUpButton
//            | PFSignUpFields.DismissButton
        self.presentViewController(logInController, animated:true, completion: nil)
        //self.presentViewController(signUpController, animated:true, completion: nil)
    
        
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true);
        println("tapped")
    }
    
    @IBAction func push(sender: UIButton) {
        let message: NSString = "Yo, Nigga!"
        
        var data = [ "title": "Some Title",
            "alert": message]
        
        //var userQuery: PFQuery = PFUser.query()
        //userQuery.whereKey("objectId", equalTo: recipientObjectId)
        var query: PFQuery = PFInstallation.query()
        //query.whereKey("currentUser", equalTo: userQuery)
        query.whereKey("installationId", equalTo: "840c3705-1403-4a71-b0ab-4c544b9537cb")
        
        var push: PFPush = PFPush()
        push.setQuery(query)
        push.setData(data)
        push.sendPushInBackground()
    }
    //@IBOutlet weak var doText: UITextField!
    @IBOutlet weak var accomplishedBar: UISlider!
    @IBAction func submitButton(sender: UIButton) {
        //var user = PFUser.currentUser()
        var somethingNew = PFObject(className: "SomethingNew")
        somethingNew.setObject(self.textField.text, forKey: "learned")
        somethingNew.setObject(self.doText.text, forKey: "did")
        //somethingNew.setObject(self.youDid.text, forKey: "did")
        somethingNew.setObject(1, forKey: "show")
        somethingNew.setObject(self.accomplishedBar.value, forKey: "accomplished")
        
        somethingNew.ACL = PFACL(user: PFUser.currentUser())
        
        somethingNew.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if true {
                NSLog("Object created with id: \(somethingNew.objectId)")
            } else {
                NSLog("%@", error)
            }
        //self.youDid.text=""
        self.doText.text=""
        self.textField.text=""
        self.accomplishedBar.value = 0

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
        //Parse Login
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {   // is user already signed in
            // Do stuff with the user
            
        } else {
            // Show the signup or login screen
        
            var logInController = PFLogInViewController()
            var signUpController = PFSignUpViewController()
            
            //let users sign up with email only
            
          
            logInController.signUpController = signUpController
            
            logInController.signUpController.delegate = self
            logInController.delegate = self
            logInController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.SignUpButton | PFLogInFields.LogInButton | PFLogInFields.PasswordForgotten
            
            logInController.signUpController.fields = PFSignUpFields.UsernameAndPassword
                | PFSignUpFields.SignUpButton
                | PFSignUpFields.DismissButton
            self.presentViewController(logInController, animated:true, completion: nil)
            //self.presentViewController(signUpController, animated:true, completion: nil)
            
        
            
        }

        
    }
    
    //Dismiss Login View Controller after Login
    
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
  
        
        //matching user to device
        let currentInstallation: PFInstallation = PFInstallation.currentInstallation()
        var user = PFUser.currentUser()
        currentInstallation.setObject(user, forKey: "user")
        currentInstallation.saveInBackground()
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
//    func registerForKeyboardNotifications ()-> Void   {
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
//        
//        
//    }
//    
//    func deregisterFromKeyboardNotifications () -> Void {
//        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
//        center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
//        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
//        
//        
//    }
//    
//    
//    func keyboardWasShown (notification: NSNotification) {
//        
//        let info : NSDictionary = notification.userInfo!
//        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
//            let insets: UIEdgeInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, keyboardSize.height, 0)
//            
//            self.scrollView.contentInset = insets
//            self.scrollView.scrollIndicatorInsets = insets
//            var frame = self.textField.frame
//            var frameDo = self.doText.frame
//            var aRect: CGRect = self.view.frame
//            aRect.size.height -= keyboardSize!.height
//            if (!CGRectContainsPoint(aRect, activeField!.frame.origin) ) {
//                let scrollPoint:CGPoint = CGPointMake(0.0, activeField!.frame.origin.y - kbSize!.height)
//                scrollView.setContentOffset(scrollPoint, animated: true)
//            }
//            
////            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + keyboardSize.height)
//        }
//        
//        
//        
//    }
//    
//    func keyboardWillBeHidden (notification: NSNotification) {
//        
//        let info : NSDictionary = notification.userInfo!
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
//            let insets: UIEdgeInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, keyboardSize.height, 0)
//            
//            self.scrollView.contentInset = insets
//            self.scrollView.scrollIndicatorInsets = insets
//            
//            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - keyboardSize.height)
//        }
//        
//        
//
//        
//        
//        
//    }
    
    var activeField: UITextView?
    
    func textViewDidBeginEditing(sender: RoundedTextView) {
        activeField = sender
       
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardOnScreen:", name: UIKeyboardDidChangeFrameNotification, object: nil)
        center.addObserver(self, selector: "keyboardOffScreen:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardOnScreen(notification: NSNotification){
        let info: NSDictionary  = notification.userInfo!
        let kbSize = info.valueForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize!.height
        //you may not need to scroll, see if the active field is already visible
        //if (!CGRectContainsPoint(aRect, activeField!.frame.origin) ) {
            let scrollPoint:CGPoint = CGPointMake(0.0, activeField!.frame.origin.y - kbSize!.height)
            scrollView.setContentOffset(scrollPoint, animated: true)
        //}
        
    }
    
    
    func keyboardOffScreen(notification: NSNotification){
        let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
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
