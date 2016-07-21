//
//  MapViewController.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 7/14/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoomLevel: 12, animated: false)
        
        mapView.delegate = self
        
        let eventPoint = MGLPointAnnotation()
        eventPoint.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        mapView.addAnnotation(eventPoint)
        
        view.addSubview(mapView)
        
    }
    
    /*func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLPointAnnotation) -> MGLAnnotationImage? {
        
        return nil
    }*/
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
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
