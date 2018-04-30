//
//  ChuMapViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/21/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class ChuMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    var chuLocation = CLLocationCoordinate2D()
    var thoLocations: [CLLocationCoordinate2D] = []
    var thoLocation = CLLocationCoordinate2D()
    var calling = false
    var accepted = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
        
        if let chuEmail = Auth.auth().currentUser?.email{
            Database.database().reference().child("NailRequest").queryOrdered(byChild: "callingEmail").queryEqual(toValue: chuEmail).observe(.childAdded, with: { (snapshot) in
              
                
                Database.database().reference().child("NailRequest").removeAllObservers()
                
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                    if let thoLat = rideRequestDictionary["lat"] as? Double {
                        if let thoLon = rideRequestDictionary["lon"] as? Double {
                            self.thoLocation = CLLocationCoordinate2D(latitude: thoLat, longitude: thoLon)
                            self.calling = true
                            self.thoLocations.append(self.thoLocation)
                            //print(self.thoLocations)
                            self.displayChuAndTho()
                            if let chuEmail = Auth.auth().currentUser?.email{
                                Database.database().reference().child("NailRequest").queryOrdered(byChild: "callingEmail").queryEqual(toValue: chuEmail).observe(.childAdded, with: { (snapshot) in
                                    if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                                        if let thoLat = rideRequestDictionary["lat"] as? Double {
                                            if let thoLon = rideRequestDictionary["lon"] as? Double {
                                                self.thoLocation = CLLocationCoordinate2D(latitude: thoLat, longitude: thoLon)
                                                self.calling = true
                                                self.displayChuAndTho()
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

    func displayChuAndTho() {
       // print(thoLocations)
        
        //        callThoBtn.setTitle("You Have an Offer! The Salon is \(roundDistance)km away", for: .normal)
        //map.removeAnnotations(map.annotations)
        
        let region = MKCoordinateRegion(center: chuLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        map.setRegion(region, animated: true)
        
        let thoAnno = MKPointAnnotation()
        thoAnno.coordinate = thoLocation
        thoAnno.title = "Your Minicurist"
        map.addAnnotation(thoAnno)
        
        let chuAnno = MKPointAnnotation()
        chuAnno.coordinate = chuLocation
        chuAnno.title = "Your shop"
        map.addAnnotation(chuAnno)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            chuLocation = center
            if calling {
                displayChuAndTho()
            }
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
