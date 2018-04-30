//
//  CallingViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/26/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class CallingViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var messLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    var thoLocation = CLLocationCoordinate2D()
    var chuLocation = CLLocationCoordinate2D()
    var thoEmail = ""
    var chuEmail = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
//        let region = MKCoordinateRegion(center: thoLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        map.setRegion(region, animated: false)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = thoLocation
//        annotation.title = thoEmail
//        map.addAnnotation(annotation)
        
        displayChuAndTho()
        
    }

    func displayChuAndTho() {
        let chuCLLocation = CLLocation(latitude: chuLocation.latitude, longitude: chuLocation.longitude)
        let thoCLLocation = CLLocation(latitude: thoLocation.latitude, longitude: thoLocation.longitude)
        let distance = chuCLLocation.distance(from: thoCLLocation) / 1000
        let roundDistance = round(distance * 100) / 100
        messLabel.text = "The Manicurist is \(roundDistance)km away"
        map.removeAnnotations(map.annotations)
        
        let latDelta = abs(chuLocation.latitude - thoLocation.latitude) * 2 + 0.005
        let lonDelta = abs(chuLocation.longitude - thoLocation.longitude) * 2 + 0.005
        
        let region = MKCoordinateRegion(center: thoLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        map.setRegion(region, animated: true)
        
        let thoAnno = MKPointAnnotation()
        thoAnno.coordinate = thoLocation
        thoAnno.title = "Manicurist"
        map.addAnnotation(thoAnno)
        
        let chuAnno = MKPointAnnotation()
        chuAnno.coordinate = chuLocation
        chuAnno.title = "Your Salon Shop"
        map.addAnnotation(chuAnno)
        
    }
    
    
    
    @IBAction func callTapped(_ sender: Any) {
        Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: thoEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["chuLat":self.chuLocation.latitude, "chuLon":self.chuLocation.longitude, "callingEmail":self.chuEmail])
            Database.database().reference().child("NailRequest").removeAllObservers()
        }
        performSegue(withIdentifier: "afterCallSegue", sender: nil)
    }
    

}
