//
//  EventViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/18/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase



class EventViewController: UIViewController{
    
    
    //Delegation
    var event = [String: AnyObject]()
    
    
    var fromEventSearch = false
    
    //Firebase Setup
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 45/255, blue: 85/255, alpha: 1)
        
        ref = FIRDatabase.database().reference()
        
        
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    @IBAction func unwindToVC(sender: UIStoryboardSegue) {
        
            if sender.identifier == "getEvent" {
                let searchEventController = sender.sourceViewController as! SearchEventTableViewController
                self.event = searchEventController.event
                
            }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if !event.isEmpty {
            if segue.identifier == "location" {
                let mapView: MapViewController = segue.destinationViewController as! MapViewController
                guard case let latitude = event["location"]!["latitude"]! else { return }
                guard case let longitude = event["location"]!["longitude"]! else { return }
                mapView.latitude = latitude as AnyObject as! Double
                mapView.longitude = longitude as AnyObject as! Double
            }
           
        }
    }
    

}
