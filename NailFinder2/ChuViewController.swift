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
    var uberHasBeenCalled = false
    var driverOnTheWay = false
    var driverLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if let email = Auth.auth().currentUser?.email{
            Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                self.uberHasBeenCalled = true
                self.callThoBtn.setTitle("Cancel Request", for: .normal)
                Database.database().reference().child("NailRequest").removeAllObservers()
                
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                  
                    if let driverLat = rideRequestDictionary["driverLat"] as? Double {
                      
                        if let driverLon = rideRequestDictionary["driverLon"] as? Double {
                       
                            self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                            self.driverOnTheWay = true
                            self.displayDriverAndRider()
                    
                            if let email = Auth.auth().currentUser?.email {
                                Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childChanged, with: { (snapshot) in
                                    if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                                        if let driverLat = rideRequestDictionary["driverLat"] as? Double {
                                            if let driverLon = rideRequestDictionary["driverLon"] as? Double {
                                                self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                                                self.driverOnTheWay = true
                                                self.displayDriverAndRider()
                                            }
                                        }
                                        
                                    }
                                })
                            }
                        }
                    }
                    
                }
            })
        }
    }
    
    
    func displayDriverAndRider() {
        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        let riderCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
     
        let roundDistance = round(distance * 100) / 100
       
        callThoBtn.setTitle("Your Driver is \(roundDistance)km away", for: .normal)
        map.removeAnnotations(map.annotations)
        
        let latDelta = abs(driverLocation.latitude - userLocation.latitude) * 2 + 0.005
        let lonDelta = abs(driverLocation.longitude - userLocation.longitude) * 2 + 0.005
        
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        map.setRegion(region, animated: true)
        
        let riderAnno = MKPointAnnotation()
        riderAnno.coordinate = userLocation
        riderAnno.title = "Your Location"
        map.addAnnotation(riderAnno)
        
        let driverAnno = MKPointAnnotation()
        driverAnno.coordinate = driverLocation
        driverAnno.title = "Your Driver"
        map.addAnnotation(driverAnno)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            
            if uberHasBeenCalled {
                if driverOnTheWay{
                    displayDriverAndRider()
                }
                
            } else {
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                map.setRegion(region, animated: true)
                map.removeAnnotations(map.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = "Your location"
                map.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callThoTapped(_ sender: Any) {
        if driverOnTheWay == false {
            if let email = Auth.auth().currentUser?.email{
                if uberHasBeenCalled {
                    uberHasBeenCalled = false
                    callThoBtn.setTitle("Call Manicurist", for: .normal)
                    Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in snapshot.ref.removeValue()
                        Database.database().reference().child("NailRequest").removeAllObservers()
                    })
                } else {
                    let rideRequestDictionary : [String:Any] = ["email": email, "lat":userLocation.latitude, "lon":userLocation.longitude]
                    Database.database().reference().child("NailRequest").childByAutoId().setValue(rideRequestDictionary)
                    uberHasBeenCalled = true
                    callThoBtn.setTitle("Cancel Your Request", for: .normal)
                }
            }
        }
    }
}
