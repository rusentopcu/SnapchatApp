//
//  ViewController.swift
//  SnapchatApp
//
//  Created by Rusen Topcu on 15.11.2020.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (auth, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "ERROR")
                }
                else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }
        
        else {
            self.makeAlert(title: "Error!", message: "Password/Email")
        }
        
        
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && usernameText.text != "" && passwordText.text != "" {
        
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "ERROR")
                }
                else {
                    
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email": self.emailText.text, "username": self.usernameText.text] as [String: Any]
                    
                    fireStore.collection("userInfo").addDocument(data: userDictionary) { (error) in
                        if (error != nil) {
                            
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
            
      }
        else {
            self.makeAlert(title: "Error!", message: "Username/Password/Email")
        }
    }
      
    
    @objc func makeAlert(title: String, message: String) {
        
        let alarm = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alarm.addAction(okButton)
        self.present(alarm, animated: true, completion: nil)
    }
    
    
}

