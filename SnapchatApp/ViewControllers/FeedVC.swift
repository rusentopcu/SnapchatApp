//
//  FeedVC.swift
//  SnapchatApp
//
//  Created by Rusen Topcu on 15.11.2020.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
      getUserInfo()
      getSnapFromFirebase()
        
    }
    
    func getSnapFromFirebase() {
        
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }
            else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 {
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    
                                    self.snapArray.append(snap)
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUserNameLabel.text = snapArray[indexPath.row].username
        return cell
    }
    
}
