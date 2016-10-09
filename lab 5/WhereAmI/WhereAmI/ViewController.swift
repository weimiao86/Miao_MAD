//
//  ViewController.swift
//  WhereAmI
//
//  Created by Wei Miao on 10/4/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        mapView.mapType=MKMapType.Hybrid //hybrid with map and satellite
        let status = CLLocationManager.authorizationStatus()
        if status==CLAuthorizationStatus.NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.distanceFilter=kCLDistanceFilterNone
        mapView.showsUserLocation=true
        super.viewDidLoad()
    }
    
    //called when a new location value is available
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(manager.location!.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        //annotations
        annotation.coordinate=manager.location!.coordinate
        annotation.title="You are here:"
        let la = manager.location!.coordinate.latitude
        let lo = manager.location!.coordinate.longitude
        annotation.subtitle="Latitude: \(la), Longitude: \(lo)"
        mapView.addAnnotation(annotation)
        
    }
    
    //called when the authorization status for the application changed.
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status==CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    //called when a location cannot be determined
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        var errorType=String()
        if let clError=CLError(rawValue: error.code) {
            if clError == .Denied {
                errorType="access denied"
                let alert=UIAlertController(title: "Error", message: errorType, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction:UIAlertAction=UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: nil)
                alert.addAction(okAction)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

