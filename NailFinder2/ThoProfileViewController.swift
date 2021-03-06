//
//  ThoProfileViewController.swift
//  NailFinder2
//
//  Created by An Nguyen on 4/27/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class ThoProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var image: UIImageView!
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    override func viewDidLoad() {
        self.hideKeyboard()
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        
        if let email = Auth.auth().currentUser?.email {
           self.emailTextfield.text = email
            Database.database().reference().child("user").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                if let userData = snapshot.value as? [String:AnyObject] {
                    if let imageURL = userData["imageURL"] as? String {
                        if let url = URL (string: imageURL){
                            self.image.sd_setImage(with: url)
                        }
                    }
                    if let name = userData["name"] as? String {
                        self.nameTextField.text = name
                    }
                    if let phone = userData["phone"] as? String {
                        self.phoneTextField.text = phone
                    }
                    
                }
            })
        }
    }

    @IBAction func addImageTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
       
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         if let imageUp = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.image = imageUp
            imageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        if imageAdded {
            //UPload IMAGE
            if let email = Auth.auth().currentUser?.email {
                let imageFolder = Storage.storage().reference().child(email)
                if let image = image.image {
                    if let imageData = UIImageJPEGRepresentation(image, 0.1){
                        imageFolder.child("\(NSUUID().uuidString).jpg").putData(imageData, metadata: nil, completion: { (metaData, error) in
                            if let error = error{
                                self.displayAlert(title: "Something went wrong", message: error.localizedDescription)
                            } else {
                                if let downloadURL = metaData?.downloadURL()?.absoluteString {
                                    if let currentUserUid = Auth.auth().currentUser?.uid {
                                        Database.database().reference().child("user").child(currentUserUid).child("imageURL").setValue(downloadURL)
                                    }
                                    //image.sd_setImage(with: downloadURL)
                                }
                                print ("uploaded")
                                
                            }
                        })
                    }
                }
            }
        }
        
        if let name = nameTextField.text {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("user").child(currentUserUid).child("name").setValue(name)
            }
        }
        if let phone = phoneTextField.text {
            if let currentUserUid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("user").child(currentUserUid).child("phone").setValue(phone)
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
    
    @IBAction func logout(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 130), animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
