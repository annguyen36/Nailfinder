//
//  chuTableViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/24/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class chuTableViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    
  
    @IBOutlet weak var table: UITableView!
   
    var rideRequests: [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var chuLocation = CLLocationCoordinate2D()
    var email = Auth.auth().currentUser?.email
    var callingState = false
    
    override func viewDidLoad() {
        table.delegate = self
        table.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        Database.database().reference().child("NailRequest").observe(.childAdded){
            (snapshot) in
            if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                if let chuLat = rideRequestDictionary["chuLat"] as? Double {
                    
                } else {
                    self.rideRequests.append(snapshot)
                    self.table.reloadData()
                }
            }
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.table.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rideRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "thoAvailableCell")
        cell.imageView?.image = UIImage(named: "girl")
        
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "thoAvailableCell", for: indexPath)
        let snapshot = rideRequests[indexPath.row]
        if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
            if let chuEmail = rideRequestDictionary["callingEmail"] as? String{
                callingState = true
            }
            
            if let email = rideRequestDictionary["email"] as? String {
                if let lat = rideRequestDictionary["lat"] as? Double {
                    if let lon = rideRequestDictionary["lon"] as? Double {
                        let driverCLLocation = CLLocation(latitude: chuLocation.latitude, longitude: chuLocation.longitude)
                        let riderCLLocation = CLLocation(latitude: lat, longitude: lon)
                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
                        let roundDistance = round(distance * 100) / 100
                        
                         if !callingState {
                            //nameLabel.text = email
                            //howFarLabel.text = "\(roundDistance)km away"
                          cell.textLabel?.text = "\(email) - \(roundDistance)km away"
                        }
                    }
                }

            }

        }
       return cell
        //return tableView.dequeueReusableCell(withIdentifier: "thoAvailableCell") as! ChuTableViewCell
    }
    
    
    
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            chuLocation = coord
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = rideRequests[indexPath.row]
        performSegue(withIdentifier: "callSegue", sender: snapshot)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? CallingViewController {
            if let snapshot = sender as? DataSnapshot {
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                    if let thoEmail = rideRequestDictionary["email"] as? String {
                        if let lat = rideRequestDictionary["lat"] as? Double {
                            if let lon = rideRequestDictionary["lon"] as? Double {
                                acceptVC.thoEmail = thoEmail
                                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                acceptVC.thoLocation = location
                                acceptVC.chuLocation = chuLocation
                                if let email = email {
                                    acceptVC.chuEmail = email
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
}
