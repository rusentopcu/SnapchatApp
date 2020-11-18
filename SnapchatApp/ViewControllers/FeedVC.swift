//
//  FeedVC.swift
//  SnapchatApp
//
//  Created by Rusen Topcu on 15.11.2020.
//

import UIKit
import Firebase

class FeedVC: UIViewController {

    let fireStoreDatabase = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      getUserInfo()
        
    }
    
    func getUserInfo() {
        
        fireStoreDatabase.collection("userInfo").whereField("email", in: [Auth.auth().currentUser?.email]).getDocuments { (snaphot, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "ERROR")
            }
            else {
                
                if snaphot?.isEmpty == false {
                    
                    for document in snaphot!.documents {
                        
                        if let username = document.get("username") as? String {
                            
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                        
                    }
                    
                }
            }
        }
        
        
    }
    
    @objc func makeAlert(title: String, message: String) {
        
        let alarm = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alarm.addAction(okButton)
        self.present(alarm, animated: true, completion: nil)
    }
    
}
