//
//  ViewController.swift
//  1
//
//  Created by Zain Khan and Amari  Bolmer on 12/6/19.
//  Copyright © 2019 Zain Khan. and Amari All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var Map: MKMapView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var buttonset: UIButton!
    @IBOutlet weak var GoButton: UIButton!
    
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 150
    var priorLocation: CLLocation?
    var strName: String? = nil
    var strNumber:  String? = nil
    
    var pinLocation: CLLocationCoordinate2D?
    
    @IBAction func getDirectionToCar(sender : UIButton)
    {
        // self.goToPin(destination: )
        print("hello there")
        self.goToPin(destination: pinLocation! )
        //        print(pinLocation as Any)
        //        print(pinLocation as Any)
        //        print(pinLocation as Any)
        //        print(pinLocation as Any)
        //        print(pinLocation as Any)
        //        print(pinLocation as Any)
        //        print(pinLocation as Any)
        
        
    }
    
    
    
    @IBAction func findUserLocationAndDropPin(sender: UIButton) {
        self.setPin()
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkLocationServices()
        Map.delegate = self
        
        
    }
//  overrride func prepare(for segue: UIStoryboard, sender: Any?){
//        if let LocationParked = segue.destination as? LocationParked{
//            LocationParked.text = textField.text
//        }
//    }

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
            //  alert letting the user know they have to turn this on.
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



extension ViewController {
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension ViewController {
    func setPin(){
        let pinForUserLocation = MKPointAnnotation()
        
        if let loc = locationManager.location
        {
            pinForUserLocation.coordinate = loc.coordinate
            pinLocation = loc.coordinate
            let getLat : CLLocationDegrees = pinLocation!.latitude
            let getLon : CLLocationDegrees = pinLocation!.longitude
            let getNewLocation:  CLLocation = CLLocation(latitude: getLat, longitude: getLon)
            
            let GeoLocation = CLGeocoder()
            GeoLocation.reverseGeocodeLocation(getNewLocation){ [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if let _ = error {
                    return
                }
                
                guard let placemarks = placemarks?.first else {
                    return
                }
                let StrNumber = placemarks.subThoroughfare ?? ""
                let StrName = placemarks.thoroughfare ?? ""
                print(StrName, StrNumber)
 
//// let tabBarController = UITabBarController()
//                let viewControllerB = TableViewControllerParked()
//                viewControllerB.selectedName = "Taylor Swift"
//                viewControllerB.delegate = self
//                navigationController?.pushViewController(viewControllerB, animated: true)

                
//                let viewControllerB = ViewController()
//                viewControllerB.selectedName = "\(StrNumber) \(StrName)"
//                viewControllerB.dothis()
                
                //                    navigationController?.pushViewController(viewControllerB, animated: true)
            }
        }
        //        self.ParkedLocation.text = \
        //                                let center = getLocation(for: Map)
        
        
        //                guard let priorLocation = self.priorLocation else {return nil}
        
        //                //                guard center.distance(from: priorLocation) > 5 else {return nil}
        //                                self.priorLocation = center
        //                                GeoLocation.reverseGeocodeLocation(center){
        //        }
        
        pinForUserLocation.title  = "Car Location"
        Map.addAnnotation(pinForUserLocation).self
        Map.showAnnotations([pinForUserLocation], animated: true)
        
        self.goToPin(destination:pinForUserLocation.coordinate)
        
        //        let GeoLocation = CLGeocoder()
        
        
        //        var centre = mapView.centerCoordinate as CLLocationCoordinate2D
        
        
        //          var getLat: CLLocationDegrees = centre.latitude
        //          var getLon: CLLocationDegrees = centre.longitude
        
        
        //          var getMovedMapCenter: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        
        
        
        
    }
    
    func goToPin(destination : CLLocationCoordinate2D){
        let CL = (locationManager.location?.coordinate)!
        
        let CLPlaceMark = MKPlacemark(coordinate: CL)
        let destPlaceMark = MKPlacemark(coordinate: destination)
        
        let CLItem = MKMapItem(placemark: CLPlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        //        print(CLItem)
        //        print(destItem)
        print("\n\n\n\n\n")
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = CLItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .walking
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { [unowned self]response, error in
            guard let unwrappedResponse = response else {
                if error != nil {
                    print("Something is wrong : ")
                }
                return
            }
            for route in unwrappedResponse.routes{
                self.Map.addOverlay((route.polyline))
                self.Map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                //                self.Map.addOverlay(route.polyline)
                //              self.Map.setVisibleMapRect((route.polyline), animated: true)
            }
            //          let route = response.routes[0]
            //          self.Map.addOverlay(route.polyline)
            //          self.Map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            //
        }
    }
    
    func Map (_ Map: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapview: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView?{
        //    func mapView (_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
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
                //                self.ParkedLocation.text = '\(
            }
        }
        
        return view
    }
    
}


