//
//  ViewController.swift
//  Parked
//
//  Created by Zain Khan on 12/5/19.
//  Copyright © 2019 Zain Khan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var ParkedMap: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    func setupLocationManager()
    {
        locationManager.delegate = (self as! CLLocationManagerDelegate)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func centerViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            ParkedMap.setRegion(region, animated: true)
            
        }
        
    }
    func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
                setupLocationManager()
                checkLocationAuthorization()
            } else {
                // Show alert letting the user know they have to turn this on.
            }
        }
        
        
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus()
            {
            case .authorizedWhenInUse:
                ParkedMap.showsUserLocation = true
                centerViewOnUserLocation()
                locationManager.startUpdatingLocation()
                break
            case .denied:
                // Show alert instructing them how to turn on permissions
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // Show an alert letting them know what's up
                break
            case .authorizedAlways:
                break
            }
        }
    
    }
