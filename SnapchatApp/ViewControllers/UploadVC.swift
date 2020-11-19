//
//  UploadVC.swift
//  SnapchatApp
//
//  Created by Rusen Topcu on 15.11.2020.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func uploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaReference = storageReference.child("media")
        
        if let imagedata = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaReference.child("\(uuid).jpg")
            
            imageReference.putData(imagedata, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "ERROR")
                }
                else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            let firestore = Firestore.firestore()
                            
                            let snapDictionary = ["imageUrl": imageUrl!, "snapOwner": UserSingleton.sharedUserInfo.username,"date": FieldValue.serverTimestamp()] as [String: Any]
                            
                            firestore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "ERRor")
                                }
                                else {
                                    self.tabBarController?.selectedIndex = 0
                                    self.uploadImageView.image = UIImage(named: "select")
                                }
                            }
                            
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
