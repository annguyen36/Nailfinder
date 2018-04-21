//
//  ViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/19/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    @IBOutlet weak var topBtn: UIButton!
    @IBOutlet weak var bottomBtn: UIButton!
    
    var signUpMode = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//TEST BEGIN
    @IBAction func testTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide email and Password")
        } else {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    if signUpMode {
                        //Sign Up
                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                if self.riderDriverSwitch.isOn {
                                    //Driver
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Driver"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "chuSegue2", sender: nil)
                                } else {
                                    //Rider
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Rider"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "chuSegue", sender: nil)
                                }
                                
                            }
                        }
                        
                    } else {
                        //Log in
                        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                if user?.displayName == "Driver" {
                                    //Driver
                                    self.performSegue(withIdentifier: "chuSegue2", sender: nil)
                                } else {
                                    //Rider
                                    self.performSegue(withIdentifier: "chuSegue", sender: nil)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
//END TEST
    
    @IBAction func topTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide email and Password")
        } else {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    if signUpMode {
                        //Sign Up
                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                if self.riderDriverSwitch.isOn {
                                    //Driver
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Driver"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                } else {
                                    //Rider
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Rider"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "chuSegue", sender: nil)
                                }
                                
                            }
                        }
                        
                    } else {
                        //Log in
                        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                if user?.displayName == "Driver" {
                                    //Driver
                                    self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                } else {
                                    //Rider
                                    self.performSegue(withIdentifier: "chuSegue", sender: nil)
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
    @IBAction func bottomTapped(_ sender: Any) {
        if signUpMode {
            topBtn.setTitle("Log In", for: .normal)
            bottomBtn.setTitle("Switch To Sign Up", for: .normal)
            driverLabel.isHidden = true
            riderLabel.isHidden = true
            riderDriverSwitch.isHidden = true
            signUpMode = false
        } else {
            topBtn.setTitle("Sign Up", for: .normal)
            bottomBtn.setTitle("Switch To Log in", for: .normal)
            driverLabel.isHidden = false
            riderLabel.isHidden = false
            riderDriverSwitch.isHidden = false
            signUpMode = true
        }
    }
    

}

