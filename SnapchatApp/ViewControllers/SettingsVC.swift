//
//  SettingsVC.swift
//  SnapchatApp
//
//  Created by Rusen Topcu on 15.11.2020.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        
        do{
        try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        }
        catch {
            print("Error")
        }
        
    }
    


}
