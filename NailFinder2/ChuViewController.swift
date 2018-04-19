//
//  ChuViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/19/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class ChuViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var callThoBtn: UIButton!
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your location"
            map.addAnnotation(annotation)
        }
    }

    @IBAction func logoutTapped(_ sender: Any) {
    }
    
    @IBAction func callThoTapped(_ sender: Any) {
        if let email = Auth.auth().currentUser?.email{
            let rideRequestDictionary : [String:Any] = ["email": email, "lat":userLocation.latitude, "lon":userLocation.longitude]
            Database.database().reference().child("NailRequest").childByAutoId().setValue(rideRequestDictionary)
        }
    }
}
