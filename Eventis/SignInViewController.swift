//
//  SignInViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/20/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase


class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func SignInButton(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        FIRAuth.auth()?.signInWithEmail(email!, password: password!) { [unowned self] (user,error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!.code) {
                    switch errorCode {
                    case .ErrorCodeWrongPassword:
                        let ac = UIAlertController(title: "Wrong Password", message: nil, preferredStyle: .Alert)
                        self.presentViewController(ac, animated: true, completion: nil)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    case .ErrorCodeUserNotFound:
                        let ac = UIAlertController(title: "User Not found", message: nil, preferredStyle: .Alert)
                        self.presentViewController(ac, animated: true, completion: nil)
                        self.dismissViewControllerAnimated(true, completion: nil)
                       
                    default:
                        print("something wrong")
                    }
                }
            }else {
                self.signedIn(user!)
            }
        }
    }
    
   
    @IBAction func SignUpButton(sender: AnyObject) {
        
        let email = emailField.text
        let password = passwordField.text
        FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user,error) in
            
            if error != nil {
                
                if let errorCode = FIRAuthErrorCode(rawValue: error!.code) {
                    switch errorCode {
                    case .ErrorCodeInvalidEmail:
                        let ac = UIAlertController(title: "Invalid Email", message: nil, preferredStyle: .Alert)
                        self.presentViewController(ac, animated: true, completion: nil)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        
                    case .ErrorCodeEmailAlreadyInUse:
                        let ac = UIAlertController(title: "Email Already in Use", message: nil, preferredStyle: .Alert)
                        self.presentViewController(ac, animated: true, completion: nil)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        print("email already in use")
                        
                    default:
                        ("you're a bozo")
                    }
                }
            }else{
                self.setDisplayName(user!)
            }
        }
    }
    
    func setDisplayName(user: FIRUser?) {
        let changeRequest = user?.profileChangeRequest()
        changeRequest?.displayName = user?.email?.componentsSeparatedByString("@")[0]
        changeRequest?.commitChangesWithCompletion() { (error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            self.signedIn((FIRAuth.auth()?.currentUser)!)
        }
    }
    
    
    func signedIn(user: FIRUser) {
        
        UserState.sharedInstance.displayName = user.displayName ?? user.email!
        UserState.sharedInstance.signedIn = true
        let signInNotification = NSNotificationCenter.defaultCenter()
        signInNotification.postNotificationName("userSignedIn", object: nil)
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            print(name)
            print(email)
        }
        let ac = UIAlertController(title: "Signed In", message: "Now you're signed In, You can now comment and host events", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: {
            self.emailField.text = ""
            self.passwordField.text = ""
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
