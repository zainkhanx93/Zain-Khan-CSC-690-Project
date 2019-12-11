//
//  ViewController.swift
//  1
//
//  Created by Zain Khan on 12/6/19.
//  Copyright © 2019 Zain Khan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var Map: MKMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var buttonset: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 150
    var priorLocation: CLLocation?
    

    @IBAction func findUserLocationAndDropPin(sender: UIButton) {
        self.setPin()
    }
    
    
    override func viewDidLoad()
      {
        super.viewDidLoad()
        checkLocationServices()

      }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus(){
        case.authorizedWhenInUse:
            Map.showsUserLocation = true
            locationManager.startUpdatingLocation()
            centerView()
            locationManager.startUpdatingLocation()
            priorLocation = getLocation(for: Map)
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
            
    func centerView() {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init (center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            Map.setRegion(region, animated:true)
        }
    }
            
    
    func getLocation (for Map: MKMapView) -> CLLocation{
        let latitude = Map.centerCoordinate.latitude
        let longitude = Map.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
        
    }
        
        }



    extension ViewController: CLLocationManagerDelegate {
        
       /* func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else
            {
                return
            }
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            Map.setRegion(region, animated: true)
        }
        */
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
    }

extension ViewController: MKMapViewDelegate {
     func setPin(){
        //var userLocationCoordinates = getLocation(for: Map)
               let pinForUserLocation = MKPointAnnotation()
               if let loc = locationManager.location
               {
                   pinForUserLocation.coordinate = loc.coordinate
               }
               //pinForUserLocation.coordinate = userLocationCoordinates.location.coordinate
               pinForUserLocation.title  = "Car Location"
//               pinForUserLocation.subtitle = "Saved Location"
               Map.addAnnotation(pinForUserLocation).self
        Map.showAnnotations([pinForUserLocation], animated: true)
        
        
        
        
    }
//    func mapView(_ Map: MKMapView, regionDidChangeAnimated animated: Bool)
    func mapView(_ mapview: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView?
    {
        var view = mapview.dequeueReusableAnnotationView(withIdentifier: "resuseIdentifer") as? MKMarkerAnnotationView
        if view == nil{
            view = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "reuseIdentifer")
        }
        view?.annotation = annotation
        view?.displayPriority = .required
       
        
        
        let center = getLocation(for: Map)
        let GeoLocation = CLGeocoder()
        
        
        guard let priorLocation = self.priorLocation else {return nil}
        
        guard center.distance(from: priorLocation) > 5 else {return nil}
        self.priorLocation = center
        GeoLocation.reverseGeocodeLocation(center){ [weak self] (placemarks, error) in
        guard let self = self else { return }
            
            if let _ = error {
                return
            }
            
            guard let placemarks = placemarks?.first else {
                return
            }
            let StNumber = placemarks.subThoroughfare ?? ""
            let StName = placemarks.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(StNumber) \(StName)"
            }
            }
        return view
        }

    }

    
