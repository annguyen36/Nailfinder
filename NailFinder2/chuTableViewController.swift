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
import SDWebImage
import Kingfisher

class chuTableViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    
  

    @IBOutlet weak var table: UITableView!
    
    var rideRequests: [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var chuLocation = CLLocationCoordinate2D()
    var email = Auth.auth().currentUser?.email
    var callingState = false
    var disclaimerHasBeenDisplayed = false
    
    override func viewDidAppear(_ animated: Bool) {
        if disclaimerHasBeenDisplayed == false {
            
            disclaimerHasBeenDisplayed = true
            
            
            Database.database().reference().child("NailRequest").observe(.childAdded){
                (snapshot) in
                
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                    if let chuEmail = rideRequestDictionary["callingEmail"] as? String{
                        if self.email == chuEmail {
                            if let thoName = rideRequestDictionary["thoName"] as? String {
                                let comming = rideRequestDictionary["commingState"] as! Bool
                                if comming {
                                    let alertController = UIAlertController(title: "\(thoName)", message: "Is comming!", preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    
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
                if let chuEmail = rideRequestDictionary["callingEmail"] as? String{
                    
                } else {
                    self.rideRequests.append(snapshot)
                    self.table.reloadData()
                    // print(self.rideRequests.count)
                }
            }
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.table.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return thoAvailable.count
        return rideRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TEST
//        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "thoAvailableCell")
//        let snapshot = rideRequests[indexPath.row]
//        if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
//            if let chuEmail = rideRequestDictionary["callingEmail"] as? String{
//                print(chuEmail)
//                callingState = true
//            }
//
//            if let email = rideRequestDictionary["email"] as? String {
//
//
//
//                if let lat = rideRequestDictionary["lat"] as? Double {
//                    if let lon = rideRequestDictionary["lon"] as? Double {
//                        let driverCLLocation = CLLocation(latitude: chuLocation.latitude, longitude: chuLocation.longitude)
//                        let riderCLLocation = CLLocation(latitude: lat, longitude: lon)
//                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
//                        let roundDistance = round(distance * 100) / 100
//
//                        if !callingState {
//                            //nameLabel.text = email
//                            //howFarLabel.text = "\(roundDistance)km away"
//                            Database.database().reference().child("user").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
//                                if let userData = snapshot.value as? [String:AnyObject] {
//                                    if let name = userData["name"] as? String {
//                                        cell.textLabel?.text = "\(name) - \(roundDistance)km away"
//                                    }
//                                }
//                            })
//                        }
//                    }
//                }
//
//            }
//
//        }
//        //END TEST
//       return cell
        
        let snapshot = rideRequests[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "thoAvailableCell", for: indexPath) as! ChuTableViewCell

        if let thoDictionary = snapshot.value as? [String:AnyObject] {
            if let chuEmail = thoDictionary["callingEmail"] as? String{
                //print(chuEmail)
                //callingState = true
                    //print("hello calling True")
            }

            if let email = thoDictionary["email"] as? String {
                
                if let lat = thoDictionary["lat"] as? Double {
                    if let lon = thoDictionary["lon"] as? Double {
                        let driverCLLocation = CLLocation(latitude: chuLocation.latitude, longitude: chuLocation.longitude)
                        let riderCLLocation = CLLocation(latitude: lat, longitude: lon)
                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
                        let roundDistance = round(distance * 100) / 100

                       // if !callingState {
                            //nameLabel.text = email
                            //howFarLabel.text = "\(roundDistance)km away"
                            Database.database().reference().child("user").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                               // print("hello In Database")
                                if let userData = snapshot.value as? [String:AnyObject] {
                                    if let name = userData["name"] as? String {
                                        cell.nameLabel.text = name
                                        cell.howFarLabel.text = "\(roundDistance) km"

                                    }
                                    if let imageURL = userData["imageURL"]{
                                        if let image = URL (string: imageURL as! String){
                                            cell.thoImage.kf.setImage(with: image)

                                        }
                                    }
                                }
                            })
                       // }
                    }
                }

            }

        }
        return cell
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
    
    func displayAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
}
