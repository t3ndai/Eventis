//
//  SearchEventTableViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 7/13/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase

class SearchEventTableViewController: UITableViewController, UISearchBarDelegate {
    
    //UI Properties
    let searchBar =  UISearchBar()
    let tap = UITapGestureRecognizer()
    
    //var event = [String: AnyObject]()
    var events = [Dictionary<String, AnyObject>](){
        didSet{
            print(events.count)
        }
    }
    //Firebase Setup 
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createSearchBar
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search for Event using EventTag"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        
        ref = FIRDatabase.database().reference()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func handleTap(recognizer: UITapGestureRecognizer){
        searchBar.resignFirstResponder()
    }
    
    /*func createSearchBar() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search for Event using EventTag"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }*/
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        tap.addTarget(self, action: #selector(SearchEventTableViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        view.removeGestureRecognizer(tap)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var eventID: String
        eventID = self.searchBar.text!
        let eventsRef = ref.child("events")
        
        eventsRef.queryOrderedByChild("eventID").queryEqualToValue(eventID).observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            
            if snapshot.exists() {
                let data = snapshot.value as! Dictionary<String, AnyObject>
                guard let eventDescription = data["eventDescription"] as! String! else { return }
                guard let eventURL = data["eventPhotoURL"] as! String! else { return }
                
                self.events.append(data)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableView.reloadData()
                })
            }else if !snapshot.exists() {
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let ac = UIAlertController(title: "", message: "Event Not Found", preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                })
            }
        })
        
        self.searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        for event in events {
            cell.textLabel?.text = event["eventDescription"] as! String!
            cell.textLabel?.sizeToFit()
        }

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

}
