//
//  EventViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/18/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase



class EventViewController: UIViewController, UISearchBarDelegate, EventImageDelegate{
    
    @IBOutlet weak var searchEventBar: UISearchBar!
    
    
    //Delegation
    var url: String = ""{
        didSet{
            print(url)
        }
    }
    var imageContainer: EventImageViewController?
    
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
                guard let eventURL = data["eventPhotoURL"] as! String! else { return }
                
                self.url = eventURL
                self.performSegueWithIdentifier("eventImageSegue", sender: self)

            }
            
        })
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func imageUrl(url: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "eventImageSegue" {
            let vc = segue.destinationViewController as! EventImageViewController
            vc.imageUrl = url
            
        }
        
    }
    

}
