//
//  ViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/19/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topBtn: UIButton!
    
    var identifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBAction func topTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide email and Password")
        } else {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    
                    //========ADMIN SIGNUP=====================
                    //                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    //                            if error != nil {
                    //                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                    //                            } else {
                    //
                    //                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                    //                                    req?.displayName = "Admin"
                    //                                    req?.commitChanges(completion: nil)
                    //                                    self.performSegue(withIdentifier: "adminSegue", sender: nil)
                    //                            }
                    //                        }
                    
                    //Log in
                    
                    
                    //============= LOGIN ===========
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            if let nameFromData = user?.displayName {
                                let separate = nameFromData.characters.split(separator: " ")
                                if let idText = separate.first {
                                    self.identifier = String(idText)
                                    print(self.identifier)
                                }
//                                if let idText = separate.last {
//                                    let Test = String(idText)
//                                    print(Test)
//                                }
                            }
                            
                            if self.identifier == "Shop" {
                                //Shop
                                self.performSegue(withIdentifier: "chuSegue2", sender: nil)
                            } else if self.identifier == "Admin" {
                                //Admin
                                self.performSegue(withIdentifier: "adminSegue", sender: nil)
                            } else {
                                //Tho
                                self.performSegue(withIdentifier: "thoSegue", sender: nil)
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func displayAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //    //TEST BEGIN
    //    @IBAction func testTapped(_ sender: Any) {
    //        if emailTextField.text == "" || passwordTextField.text == "" {
    //            displayAlert(title: "Missing Information", message: "You must provide email and Password")
    //        } else {
    //            if let email = emailTextField.text {
    //                if let password = passwordTextField.text {
    //                    if signUpMode {
    //                        //Sign Up
    //                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
    //                            if error != nil {
    //                                self.displayAlert(title: "Error", message: error!.localizedDescription)
    //                            } else {
    //                                if self.riderDriverSwitch.isOn {
    //                                    //Driver| CHU
    //                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
    //                                    req?.displayName = "Driver"
    //                                    req?.commitChanges(completion: nil)
    //                                    self.performSegue(withIdentifier: "chuSegue2", sender: nil)
    //                                } else {
    //                                    //Rider | THO
    //                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
    //                                    req?.displayName = "Rider"
    //                                    req?.commitChanges(completion: nil)
    //                                    self.performSegue(withIdentifier: "thoSegue", sender: nil)
    //                                }
    //
    //                            }
    //                        }
    //
    //                    } else {
    //                        //Log in
    //                        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
    //                            if error != nil {
    //                                self.displayAlert(title: "Error", message: error!.localizedDescription)
    //                            } else {
    //                                if user?.displayName == "Driver" {
    //                                    //Driver
    //                                    self.performSegue(withIdentifier: "chuSegue2", sender: nil)
    //                                } else {
    //                                    //Rider
    //                                    self.performSegue(withIdentifier: "thoSegue", sender: nil)
    //                                }
    //
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    //    //END TEST
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


