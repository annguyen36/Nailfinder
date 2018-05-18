//
//  TableNewViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 5/1/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit
import SDWebImage
import Kingfisher

class TableNewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var rideRequests: [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var chuLocation = CLLocationCoordinate2D()
    var email = Auth.auth().currentUser?.email
    var callingState = false
   
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        Database.database().reference().child("NailRequest").observe(.childAdded){
//            (snapshot) in
//            if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
////                if let chuEmail = rideRequestDictionary["chuEmail"] as? String{
//////                    if self.email == chuEmail {
//////                        if let thoName = rideRequestDictionary["thoName"] as? String {
//////                            let comming = rideRequestDictionary["commingState"] as! Bool
//////                            if comming {
//////                                self.displayAlert(title: "\(thoName)", message: "Is comming!")
//////                            }
//////
//////                        }
//////                    }
////                } else {
////                    self.rideRequests.append(snapshot)
////                    self.table.reloadData()
////                }
//                if let chuLat = rideRequestDictionary["chuLat"] as? Double {
//
//                } else {
//                    self.rideRequests.append(snapshot)
//                    self.table.reloadData()
//                }
//            }
//        }
        Database.database().reference().child("NailRequest").observe(.childAdded){
            (snapshot) in
            
            if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                if let chuLat = rideRequestDictionary["chuLat"] as? Double {
                    
                } else {
                    print("Should add")
                    self.rideRequests.append(snapshot)
                    self.table.reloadData()
                    print(self.rideRequests.count)
                }
            }
            
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.table.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "availableCell", for: indexPath) as! NewAvailableTableViewCell
        return cell
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            chuLocation = coord
        }
    }
    func displayAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
 
}
