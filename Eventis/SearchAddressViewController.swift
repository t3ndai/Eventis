//
//  SearchAddressViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/23/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder
import CoreLocation

class SearchAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchAddressTextBar: UISearchBar!
    
    @IBOutlet weak var searchResultsTbl: UITableView!
    
    var geocoder = Geocoder.sharedGeocoder
    var geocodingDataTask: NSURLSessionDataTask?
    
    var searchResults = [GeocodedPlacemark]()
    
    var latitude: Double!
    var longitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchAddressTextBar.delegate = self
        
        self.searchResultsTbl.delegate = self
        self.searchResultsTbl.dataSource = self
        self.searchResultsTbl.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchAddressTextBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchAddressTextBar: UISearchBar) {
        //now begin search 
        
        var searchAddress = searchAddressTextBar.text
        
        let options = ForwardGeocodeOptions(query: searchAddress!)
        
        geocodingDataTask = geocoder.geocode(options: options) { (placemarks, attribution, error) in
            
            do {
                self.searchResults.removeAll()
                if placemarks == nil {
                    return
                }
                else {
                    for placemark in placemarks! {
                        self.searchResults.append(placemark)
                    }
                }
            }
            catch error! as NSError {
                print(error?.localizedDescription)
            }
            
        }
        
        self.searchResultsTbl.reloadData()
        searchAddressTextBar.resignFirstResponder()
    }
    
    func searchBar(searchAddressTextBar: UISearchBar, textDidChange searchText: String) {
        
        let options = ForwardGeocodeOptions(query: searchText)
        
        geocodingDataTask = geocoder.geocode(options: options) { (placemarks, attribution, error) in
            
            for placemark in placemarks! {
                self.searchResults.append(placemark)
            }
        }
        
        self.searchResultsTbl.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell!
        
        for placemark in searchResults {
            cell.textLabel?.text = placemark.qualifiedName
            cell.textLabel?.sizeToFit()
        }
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var index: Int = indexPath.row
        
        var placemark = searchResults[index]
        var coordinate = placemark.location.coordinate
        
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        
       // print(latitude)
       // print(longitude)
        
        let ac = UIAlertController(title: "Coordinates", message: "\(coordinate.latitude), \(coordinate.longitude)", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Selected", style: .Default, handler: nil))
        presentViewController(ac, animated: true , completion: nil)
        //dismissViewControllerAnimated(true, completion: nil)
        
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
