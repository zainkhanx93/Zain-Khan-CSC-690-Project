//
//  ViewController.swift
//  1
//
//  Created by Zain Khan on 12/6/19.
//  Copyright © 2019 Zain Khan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var Map: MKMapView!
    
    override func viewDidLoad()
      {
        super.viewDidLoad()
        checkLocationServices()
      }
      


    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
        
  
    func setupLocationManager()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
                switch CLLocationManager.authorizationStatus(){
                case .authorizedWhenInUse:
                    Map.showsUserLocation = true
                  //  centerViewOnUserLocation()
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


    extension ViewController: CLLocationManagerDelegate {
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        }
        
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            //checkLocationAuthorization()
        }
    }

