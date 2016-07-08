//
//  EventViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/18/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase

class EventViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchEventBar: UISearchBar!
    
    //Firebase Setup
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchEventBar.delegate = self
        
        ref = FIRDatabase.database().reference()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var eventID: String
        eventID = searchEventBar.text!
        var eventsRef = ref.child("events")
       
        eventsRef.queryOrderedByChild("eventID").queryEqualToValue(eventID).observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            
            if snapshot.exists() {
                let data = snapshot.value as! Dictionary<String, AnyObject>
                guard let eventDescription = data["eventDescription"] as! String! else { return }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                   print(eventDescription)
                })
            }
            
        })
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
