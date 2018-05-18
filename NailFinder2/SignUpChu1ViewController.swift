//
//  SignUpChu1ViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 5/5/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpChu1ViewController: UIViewController {

    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var nameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var confirmPassTextField: LoginTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nextTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" || confirmPassTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide email and Password")
        } else if confirmPassTextField.text != passwordTextField.text {
            displayAlert(title: "Password doesn't match", message: "Please check your password again!")
        } else {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            if let name = self.nameTextField.text {
                                req?.displayName = "Shop " + name
                            }
                            req?.commitChanges(completion: nil)
                            if let user = user {
                                Database.database().reference().child("user").child(user.uid).child("email").setValue(email)
                                Database.database().reference().child("user").child(user.uid).child("role").setValue("Shop")
                                
                                if let name = self.nameTextField.text {
                                    Database.database().reference().child("user").child(user.uid).child("name").setValue(name)
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

}
