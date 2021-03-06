//
//  AcceptRequestViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/19/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase


class AcceptRequestViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var requestLocation = CLLocationCoordinate2D()
    var chuLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: false)
       let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requestEmail
        map.addAnnotation(annotation)
    }

    @IBAction func acceptTapped(_ sender: Any) {
        //Update Ride request

        Database.database().reference().child("NailRequest").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["chuLat":self.chuLocation.latitude, "chuLon":self.chuLocation.longitude, "callingEmail":self.email])
            Database.database().reference().child("NailRequest").removeAllObservers()
        }
        //Give Direction
//        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
//        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
//            if let placemarks = placemarks {
//                if placemarks.count > 0 {
//                    let placemark = MKPlacemark(placemark: placemarks[0])
//                    let mapItem = MKMapItem(placemark: placemark)
//                    mapItem.name = self.requestEmail
//                    let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
//                    mapItem.openInMaps(launchOptions: options)
//                }
//            }
//        }
        
        //Inform Tho ontheway
        
        
        
    }
    

}
