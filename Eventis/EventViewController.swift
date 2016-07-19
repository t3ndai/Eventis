//
//  EventViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/18/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase


enum Segments: Int {
    case HostUpdates
    case UserComments
}

class EventViewController: UIViewController{

    //Delegation
    var event = [String: AnyObject]()
    
    @IBOutlet weak var segmentContainerControl: UISegmentedControl!
    weak var currentViewController: UIViewController?
    
    @IBOutlet weak var hostUpdatesContainer: UIView!
    @IBOutlet weak var userCommentsContainer: UIView!
    
    
    
    
    //Firebase Setup
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 45/255, blue: 85/255, alpha: 1)
        
        ref = FIRDatabase.database().reference()
        
        segmentContainerControl.addTarget(self, action: "segmentedContainers:", forControlEvents: .ValueChanged)
        hostUpdatesContainer.hidden = false
        userCommentsContainer.hidden = true
        
        
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
    
    @IBAction func segmentedContainers(sender: AnyObject) {
        
        let selectedContainer = Segments(rawValue: sender.selectedSegmentIndex)!
        
        switch selectedContainer {
        case .HostUpdates:
            hostUpdatesContainer.hidden = false
            userCommentsContainer.hidden = true
            
        case .UserComments:
            userCommentsContainer.hidden = false
            hostUpdatesContainer.hidden = true
            
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
   
  
    
    

}
