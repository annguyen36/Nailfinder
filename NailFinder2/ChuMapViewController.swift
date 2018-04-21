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

class ChuMapViewController: UIViewController {
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    
    @IBAction func LogoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
