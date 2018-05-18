//
//  SignUpChu2ViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 5/5/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpChu2ViewController: UIViewController {

    @IBOutlet weak var streetTextField: LoginTextField!
    
    @IBOutlet weak var street2TextField: LoginTextField!
    
    @IBOutlet weak var cityTextField: LoginTextField!
    
    
    @IBOutlet weak var zipTextField: LoginTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpTapped(_ sender: Any) {
        if let street1 = streetTextField.text {
            if let street2 = street2TextField.text {
                if let city = cityTextField.text {
                    if let zip = zipTextField.text {
                        if let currentUserUid = Auth.auth().currentUser?.uid {
                            let address = "\(street1) \(street2), \(city) \(zip)"
                            Database.database().reference().child("user").child(currentUserUid).child("address").setValue(address)
                        }
                    }
                }
            }
        }
        self.performSegue(withIdentifier: "chuSegue3", sender: nil)
    }
    


}
