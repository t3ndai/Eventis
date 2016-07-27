//
//  UserCommentsViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 7/18/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase


class UserCommentsViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var commentInput = UITextView()
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var commentsTable: UITableView!
    
    
    
    let tap = UITapGestureRecognizer()
    
    //Firebase Setup 
    var ref: FIRDatabaseReference!
    var eventComments = [Dictionary<String, AnyObject>]()
    var comment = [String: AnyObject]()
    var event = [String: AnyObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.commentsTable.delegate = self
        self.commentsTable.dataSource = self
        self.commentsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.commentsTable.addGestureRecognizer(tap)
       
        
        self.commentInput!.layer.cornerRadius = 6
        self.commentInput?.textContainer.maximumNumberOfLines = 3
        self.commentInput?.textContainer.lineBreakMode = .ByTruncatingTail
        
        commentInput!.delegate = self
        let notficationCenter = NSNotificationCenter.defaultCenter()
        notficationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        notficationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        ref = FIRDatabase.database().reference()
        
    }
    
    func loadEventID(notification: NSNotification) {
        event = notification.object as! [String: AnyObject]
    }
    
    func loadComments(){
        if !event.isEmpty {
            var eventID = event["eventID"]! as AnyObject as! String
            let commentsRef = ref.child("comments/\(eventID)")
            
            commentsRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                
                if snapshot.exists() {
                    let data = snapshot.value as! Dictionary<String, AnyObject>
                    self.eventComments.append(data)
                    print("found")
                }
                
            })
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadEventID), name: "eventSelected", object: nil)
        loadComments()
    }
 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell!
        
        return cell
    }
   
    
    @IBAction func sendComment(sender: AnyObject) {
        
        if !event.isEmpty {
            let eventID = event["eventID"]! as AnyObject as! String
            let key = self.ref.child("comments").childByAutoId().key
            
            if UserState.sharedInstance.signedIn {
                let userComment: [String: AnyObject] = ["name": UserState.sharedInstance.displayName!,
                    "comment": (commentInput?.text)!]
                
                let childUpdate = ["comments/\(eventID)/\(key)": userComment]
            
                self.ref.updateChildValues(childUpdate, withCompletionBlock: { [unowned self] (error: NSError?, ref: FIRDatabaseReference!) in
                    
                    if error != nil {
                        print("data could not be saved")
                    }else{
                        self.commentInput?.text = nil
                    }
                    
                })
                
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        if commentInput!.resignFirstResponder() {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if commentInput!.isFirstResponder() {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y -= keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if commentInput!.text.isEmpty{
            self.sendBtn.hidden = true
        }else{
            self.sendBtn.hidden = false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func deregisterFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
   
    
    /*func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
        return textView.text.characters.count < 255
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
