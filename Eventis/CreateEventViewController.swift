//
//  CreateEventViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/20/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, UITextViewDelegate, UITextFieldDelegate{
    
    
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventSwitch: UISwitch!
    
    
    var input: UIView?

    var downloadURL: String!

    var latitude: Double! = 0
    var longitude: Double! = 0
    
    var eventLive: Bool!
    
    //Set Up Firebase 
    var ref: FIRDatabaseReference!
    
    var imageData: NSData!

    var storageRef: FIRStorageReference!
    
    let host = FIRAuth.auth()?.currentUser?.displayName!
    
    
    //NSOperations for dependencies 
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        configureStorage()

        eventNameField.delegate = self
        eventDescription.delegate = self

        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().referenceForURL("gs://project-3214782734611601223.appspot.com")
    }
    
    @IBAction func getLocation(sender: AnyObject) {
        
        self.performSegueWithIdentifier("getLocationAddress", sender: self)
    }
    
    
    @IBAction func uploadEventImage(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func EventLive(sender: AnyObject) {
        
        if eventSwitch.on { eventLive = true }
        else { eventLive = false }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var eventImage: UIImage
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            eventImage = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            eventImage = possibleImage
        } else {
            return
        }
        eventImageView.contentMode = .ScaleAspectFit
        eventImageView.image = eventImage
        imageData = UIImageJPEGRepresentation(eventImage, 1)
        
        let filepath = host! + "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let eventImagesRef = storageRef.child("eventImages")
        
        let eventImageRef = eventImagesRef.child(filepath)
        
        eventImageRef.putData(self.imageData!, metadata: metadata).observeStatus(.Success) { (snapshot) in
            
            let downloadTxt = snapshot.metadata!.downloadURL()!.absoluteString
            
            self.downloadURL = downloadTxt
            print(self.downloadURL)
        }
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
        
        if segue.identifier == "getLocationAddress" {
            
            var vc = segue.destinationViewController as! UIViewController
            var controller = vc.popoverPresentationController
            
            if controller != nil {
                controller?.delegate = self
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if eventDescription.isFirstResponder() {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y -= keyboardSize.height
        }
        }
        
    }
 
    
    func keyboardWillHide(notification: NSNotification) {
        
        if eventDescription.resignFirstResponder() {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            self.view.frame.origin.y += keyboardSize.height
        }
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
     
        eventNameField.resignFirstResponder()
        return true
        
    }
        
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        let searchAddressController: SearchAddressViewController = popoverPresentationController.presentedViewController as! SearchAddressViewController
        
        latitude = searchAddressController.latitude
        longitude = searchAddressController.longitude
        
        print(latitude)
        print(longitude)
        
    }
    
    
    @IBAction func uploadEvent(sender: AnyObject) {
        
       
        var eventName = eventNameField.text

        let eventSpace = (eventName! + host!.substringWithRange(host!.startIndex...host!.startIndex.advancedBy(2))).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let eventID = eventSpace.stringByReplacingOccurrencesOfString(" ", withString: "")
    
        var queue = NSOperationQueue()
        
            
            let key = self.ref.child("events").childByAutoId().key
        
        let event: [String: AnyObject] = ["eventID": eventID,
                         "host": host!,
                         "eventDescription": self.eventDescription.text!,
                         "location": [ "latitude": self.latitude, "longitude": self.longitude],
                        "eventPhotoURL": self.downloadURL!
                         
            ]
        let childUpdates = ["/events/\(key)": event,
                                "/user-events/\(host!)/\(key)" : event]
            self.ref.updateChildValues(childUpdates)
        
    }
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
    }
    

}
