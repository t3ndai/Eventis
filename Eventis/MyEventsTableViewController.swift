//
//  MyEventsTableViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 8/1/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase

class MyEventsTableViewController: UITableViewController {
    
    
    var ref: FIRDatabaseReference!
    var events = [Dictionary<String, String>]()
    var postTextField: UITextField!
    var eventTagAtIndex: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        ref = FIRDatabase.database().reference()
        
        //loadUserEvents()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadUserEvents()
    }
    
    func loadUserEvents(){
        if UserState.sharedInstance.signedIn {
            let userName = UserState.sharedInstance.displayName!
            let userRef = ref.child("user-events/\(userName)")
            
            userRef.observeEventType(.ChildAdded, withBlock: { [unowned self] (snapshot) in
                
                if snapshot.exists() {
                    let data = snapshot.value as! Dictionary<String, AnyObject>
                    let eventName = data["eventName"] as! String
                    let eventTag = data["eventID"] as! String
                    
                    let event = ["eventName": eventName, "eventTag": eventTag]
                    self.events.append(event)
                    
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ [unowned self] Void in
                        self.tableView.reloadData()
                    })
                }
            })
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EventListTableViewCell
        // Configure the cell...
        
        let event = events[indexPath.row]
        cell.eventName.text = event["eventName"]!
        cell.eventName.sizeToFit()
        cell.eventTag.text = event["eventTag"]!
        cell.eventTag.sizeToFit()
        
        
        //Button click inside cell
        cell.postUpdate.tag = indexPath.row
        cell.postUpdate.addTarget(self, action: #selector(postUpdate), forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        self.events.removeAll()
    }
    
    @IBAction func postUpdate(sender: AnyObject) {
        
        let ac = UIAlertController(title: "Post Update", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler { (textfield) in
            self.postTextField = textfield
        }
        let event = events[sender.tag]
        eventTagAtIndex = event["eventTag"]!
        ac.addAction(UIAlertAction(title: "Post", style: .Default, handler: post))
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func post(alert: UIAlertAction) {
        let postText = postTextField.text!
        let userName = UserState.sharedInstance.displayName!
        
        if postText != "" {
            let hostUpdate: [String: String] = ["host": userName, "update": postText]
            let key = self.ref.child("host-updates").childByAutoId().key
            
            let childUpdate = ["host-updates/\(eventTagAtIndex)/\(key)": hostUpdate]
            
            self.ref.updateChildValues(childUpdate, withCompletionBlock: { [unowned self] (error: NSError?, ref: FIRDatabaseReference!) in
                if error != nil {
                    print("could not post")
                }
            })
    
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
