//
//  SignUpViewController.swift
//  
//
//  Created by Cristian Duguet on 5/10/15.
//
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet var genderSwitch: UISwitch!
    
    @IBOutlet var profilePic: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user =  PFUser.currentUser()!
                
        // -------------------- Load and save user Information -------------------------------------
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
                    user["username"] = userName
                } else {println("No username fetched")}
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    println("User Email is: \(userEmail)")
                    user["email"] = userEmail
                } else  {println("No email address fetched")}
                if let userGender : NSString = result.valueForKey("gender") as? NSString {
                    println("User Gender is: \(userGender)")
                    user["gender"] = userGender
                } else {println("No gender fetched") }
                
                user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success == false{
                        self.displayAlert("Could not Save User Info", error: "Please try again later")
                    } else {
                        println("User Information has been saved successfully!")
                    }
                })
            }
        })
        
        // ------------------- Load and Save user Profile Picture  -------------------------------
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                if let profilePicURL : String  = (result.valueForKey("data")!).valueForKey("url") as? String {
                    //println("The profile picture url is: \(profilePicURL)")
                    
                    let url = NSURL(string: profilePicURL)
                    let urlRequest = NSURLRequest(URL: url!)
                    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        (response, data, error) in
                        
                        let image = UIImage(data: data)
                        self.profilePic.image = image
                        println( "Success")
                        
                        
                        // ------------------ save image as png in Parse --------------------
                        let imageData = UIImagePNGRepresentation(self.profilePic.image)
                        let imageFile = PFFile(name: "image.png", data: imageData)
                        user["profilePic"] = imageFile
                        
                        user.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success == false{
                                self.displayAlert("Could not Save User Image", error: "Please try again later")
                            } else {
                                println("ProfilePic has been saved successfully!")
                            }
                        })
                    })
                } else { println("No profile pic URL fetched") }
            } else {
                println("\(error)")
            }
        })
    }
    
    // **************** FUNCTION: Signing Up **********************************
    @IBAction func signUpButton(sender: AnyObject) {
        var user = PFUser.currentUser()!
        if genderSwitch.on {
            user["interestedIn"] = "female"
        } else {
            user["interestedIn"] = "male"
        }
        user.saveInBackground()
    }

    // **************** FUNCTION: Send Error Alert ****************************
    func displayAlert(title: String, error: String) {
        // add alert
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        // add action to alert
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        //show alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //********************************* Facebook Functions **************************************
    func returnUserData()
    {
        
    }
    //*******************************************************************************************

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
