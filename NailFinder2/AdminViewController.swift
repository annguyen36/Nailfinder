//
//  AdminViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/27/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AdminViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func createTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide email and Password")
        } else if confirmPasswordTextField.text != passwordTextField.text {
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
                            self.displayAlert(title: "Success", message: "Your Shop Have been created!")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
