//
//  ViewController.swift
//  Tinder
//
//  Created by Cristian Duguet on 5/2/15.
//  Copyright (c) 2015 CrowdTransfer. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var permissions = ["public_profile", "email", "user_likes"]
 
    @IBOutlet var loginCancelledLabel: UILabel!
    
    // **************************** VIEWDIDLOAD **************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        // -------------------------------- Facebook -----------------------------------
        //      comment: only for fb login SDK 4.x, not integrated with Parse
        /*
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {  // User is already logged in, do work such as go to next view controller.
            println("User Logged in through Facebook")
        } else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = permissions
            loginView.delegate = self
        }
        */
        
        
        // ----------------------------- Push Notification -----------------------------
        var push = PFPush()
                 push.sendPushInBackgroundWithBlock { (isSuccessful, error) -> Void in
            println(isSuccessful)
        }
        
        // ---------------------------- Check if user is logged in ---------------------
        if PFUser.currentUser() != nil {
            println("parse: User already logged in")
        }
        
    }
    
    
    
    
    
    // ************************************* FACEBOOK Login functions ***********************************************
    //  *********************** Parse Facebook Login Button *********************************
    @IBAction func signUp(sender: AnyObject) {
        
        self.loginCancelledLabel.alpha = 0
        // ------------- Parse Facebook Login --------------------
        PFFacebookUtils.logInInBackgroundWithReadPermissions(self.permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("New user signed up and logged in through Facebook!")
                    //self.returnUserData()
                    self.performSegueWithIdentifier("signUpSegue", sender: self)
                    
                } else {
                    println("Old user logged in through Facebook!")
                    //self.returnUserData()
                    self.performSegueWithIdentifier("signUpSegue", sender: self)
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
                self.loginCancelledLabel.alpha = 1
            }
        })
    }

    
    // Only Facebook SDK 4
    /*
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) {
            println(error) // Process error
        } else if result.isCancelled { // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
        returnUserData()
    } */
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                if let userName : NSString = result.valueForKey("name") as? NSString {
                    println("User Name is: \(userName)")

                } else {println("No username fetched")}
                
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    println("User Email is: \(userEmail)")
                } else  {println("No email address fetched")}
                
                if let userGender : NSString = result.valueForKey("gender") as? NSString {
                    println("User Gender is: \(userGender)")
                } else {println("No gender fetched") }
            }
        })
    }
    
    // ************************************** OTHER FUNCTIONS ********************************************************
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

