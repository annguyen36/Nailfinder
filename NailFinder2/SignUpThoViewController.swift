//
//  SignUpThoViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/26/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpThoViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var confirmpassTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createTapped(_ sender: Any) {
        print("hello")
        if emailTextField.text == "" || passwordTextField.text == "" || confirmpassTextField.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide email and Password")
        } else if confirmpassTextField.text != passwordTextField.text {
            displayAlert(title: "Password doesn't match", message: "Please check your password again")
        } else {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            self.displayAlert(title: "Error", message: error!.localizedDescription)
                        } else {
                            //Rider
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Manicurist"
                            req?.commitChanges(completion: nil)
                            self.displayAlert(title: "Success", message: "Create your manicurist successful, Your manicurist can login to the app now!")
                            //ADD To user DB
                            if let user = user {
                                Database.database().reference().child("user").child(user.uid).child("email").setValue(email)
                                Database.database().reference().child("user").child(user.uid).child("role").setValue("Manicurist")
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

}
