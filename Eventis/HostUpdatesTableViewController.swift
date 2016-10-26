//
//  HostUpdatesTableViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/18/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase

class HostUpdatesTableViewController: UITableViewController {
    
    var event = Dictionary<String, AnyObject>(){
        didSet{
            print("recieved data")
        }
    }
    
    var ref: FIRDatabaseReference!
    
    var updates = [Dictionary<String, String>]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.separatorColor = UIColor.clearColor()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        /*let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(loadEvent) , name: "eventSelected", object: nil)*/
        
        ref = FIRDatabase.database().reference()
        
    }
    
    func loadEvent(notification: NSNotification) {
        
        event = notification.object as! [String: AnyObject]
        let description = event["eventDescription"]! as AnyObject as! String
        let host = event["host"]! as AnyObject as! String
        
        let hostUpdate = ["host": host, "update": description]
        
        self.updates.append(hostUpdate)
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableView.reloadData()
        })
       
        
    }
    
    func getUpdates() {
        if !event.isEmpty {
            let eventTag = event["eventID"]! as AnyObject as! String
            let updatesRef = ref.child("host-updates/\(eventTag)")
            
            updatesRef.observeEventType(.ChildAdded, withBlock: { [unowned self] (snapshot) in
                
                if snapshot.exists() {
                    let data = snapshot.value as! Dictionary<String, AnyObject>
                    let host = data["host"] as! String
                    let update = data["update"] as! String
                    
                    let hostUpdate = ["host": host, "update": update]
                    
                    self.updates.append(hostUpdate)
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.tableView.reloadData()
                    })
                }
                
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
       //let notificationCenter = NSNotificationCenter().defaultCenter()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadEvent) , name: "eventSelected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getUpdates), name: "eventSelected", object: nil)
        
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
        return updates.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HostUpdateTableViewCell

        /*if !event.isEmpty {
            let description = event["eventDescription"]! as AnyObject as! String
            let host = event["host"]! as AnyObject as! String
    
            cell.hostName.text = host
            cell.hostName.sizeToFit()
            cell.hostUpdate.text = description
        }*/
        
        let update = updates[indexPath.row]
        cell.hostName.text = update["host"]!
        cell.hostName.sizeToFit()
        cell.hostUpdate.text = update["update"]!
        
        
        return cell
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

}
