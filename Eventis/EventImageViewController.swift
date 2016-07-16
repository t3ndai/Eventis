//
//  EventImageViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 7/8/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit

class EventImageViewController: UIViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    var imageUrl: String = "" {
        didSet{
            
        }
    }
    var event = [String: AnyObject]()
    
    //Setup Delegation
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loadImage()
    }
    
   
    func loadImage() {
        
        if !event.isEmpty {
            imageUrl = event["eventPhotoURL"]! as AnyObject as! String
            if imageUrl != "" {
                let url = NSURL(string: imageUrl)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.eventImageView.image = image
                })
            }
        }
    }
    
    @IBAction func unwindToImageVC (sender: UIStoryboardSegueWithCompletion){
        if sender.identifier == "getImage" {
            let searchEventController = sender.sourceViewController as! SearchEventTableViewController
            self.event = searchEventController.event
        }
        
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
        
        
    }
    

}
