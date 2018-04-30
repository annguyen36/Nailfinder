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

class ThoViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var youHaveAnOfferLabel: UILabel!
    @IBOutlet weak var messLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var avaSwitch: UISwitch!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var callThoBtn: UIButton!
    var locationManager = CLLocationManager()
    var thoLocation = CLLocationCoordinate2D()
    var availableState = false
    var callingFromChu = false
    var chuLocation = CLLocationCoordinate2D()
    var chuEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //switch control
//        if self.avaSwitch.isOn {
//            self.callThoBtn.setTitle("AVAILABLE", for: .normal)
//        } else {
//            self.callThoBtn.setTitle("BUSY", for: .normal)
//        }
    
        
        
        if let email = Auth.auth().currentUser?.email{
            Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                self.availableState = true
                self.callThoBtn.setTitle("AVAILABLE", for: .normal)
                self.avaSwitch.isOn = true
                Database.database().reference().child("NailRequest").removeAllObservers()
                
                //WHEN SHOPOWNER CALL
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                  
                    if let driverLat = rideRequestDictionary["chuLat"] as? Double {
                      
                        if let driverLon = rideRequestDictionary["chuLon"] as? Double {
                       
                            self.chuLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                            self.callingFromChu = true
                            self.callThoBtn.isHidden = true
                            self.avaSwitch.isHidden = true
                            self.youHaveAnOfferLabel.isHidden = false
                            self.acceptBtn.isHidden = false
                            self.displayChuAndTho()
                            
                            if let email = Auth.auth().currentUser?.email {
                                Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childChanged, with: { (snapshot) in
                                    if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                                        if let driverLat = rideRequestDictionary["chuLat"] as? Double {
                                            if let driverLon = rideRequestDictionary["chuLon"] as? Double {
                                                self.chuLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                                                self.callingFromChu = true
                                                self.displayChuAndTho()
                                                if let chuEmailtemp = rideRequestDictionary["callingEmail"] as? String {
                                                    self.chuEmail = chuEmailtemp
                                                }
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
        let chuCLLocation = CLLocation(latitude: chuLocation.latitude, longitude: chuLocation.longitude)
        let thoCLLocation = CLLocation(latitude: thoLocation.latitude, longitude: thoLocation.longitude)
        let distance = chuCLLocation.distance(from: thoCLLocation) / 1000
     
        let roundDistance = round(distance * 100) / 100
        messLabel.text = "The Salon is \(roundDistance)km away"
//        callThoBtn.setTitle("You Have an Offer! The Salon is \(roundDistance)km away", for: .normal)
        map.removeAnnotations(map.annotations)
        
        let latDelta = abs(chuLocation.latitude - thoLocation.latitude) * 2 + 0.005
        let lonDelta = abs(chuLocation.longitude - thoLocation.longitude) * 2 + 0.005
        
        let region = MKCoordinateRegion(center: thoLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        map.setRegion(region, animated: true)
        
        let thoAnno = MKPointAnnotation()
        thoAnno.coordinate = thoLocation
        thoAnno.title = "Your Location"
        map.addAnnotation(thoAnno)
        
        let chuAnno = MKPointAnnotation()
        chuAnno.coordinate = chuLocation
        chuAnno.title = "Your Salon Shop"
        map.addAnnotation(chuAnno)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            thoLocation = center
            
            if availableState {
                if callingFromChu{
                    displayChuAndTho()
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
    
    
    @IBAction func acceptTapped(_ sender: Any) {
        questionLabel.isHidden = false
        yesBtn.isHidden = false
        noBtn.isHidden = false
        acceptBtn.isHidden = true
        youHaveAnOfferLabel.isHidden = true
        messLabel.isHidden = true
        
    }
    
    @IBAction func noTapped(_ sender: Any) {
        callThoBtn.isHidden = false
        avaSwitch.isHidden = false
        questionLabel.isHidden = true
        yesBtn.isHidden = true
        noBtn.isHidden = true
        if let email = Auth.auth().currentUser?.email{
            callingFromChu = false
            availableState = false
            avaSwitch.isOn = false
            callThoBtn.setTitle("BUSY", for: .normal)
            Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in snapshot.ref.removeValue()
                Database.database().reference().child("NailRequest").removeAllObservers()
            })
        }
        
    }
    
    
    @IBAction func yesTapped(_ sender: Any) {
        //UPDATE INFORMATION
        
        //give direction
        let requestCLLocation = CLLocation(latitude: chuLocation.latitude, longitude: chuLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let placemark = MKPlacemark(placemark: placemarks[0])
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = self.chuEmail
                    let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
                }
            }
        }
    }
    
    @IBAction func callThoTapped(_ sender: Any) {
        if callingFromChu == false {
            if let email = Auth.auth().currentUser?.email{
                if availableState {
                    availableState = false
                    avaSwitch.isOn = false
                    callThoBtn.setTitle("BUSY", for: .normal)
                    Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in snapshot.ref.removeValue()
                        Database.database().reference().child("NailRequest").removeAllObservers()
                    })
                } else {
                    let rideRequestDictionary : [String:Any] = ["email": email, "lat":thoLocation.latitude, "lon":thoLocation.longitude]
                    Database.database().reference().child("NailRequest").childByAutoId().setValue(rideRequestDictionary)
                    availableState = true
                    avaSwitch.isOn = true
                    callThoBtn.setTitle("AVAILABLE", for: .normal)
                }
            }
        }
    }
}
