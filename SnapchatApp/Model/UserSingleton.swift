//
//  UserSingleton.swift
//  SnapchatApp
//
//  Created by Rusen Topcu on 18.11.2020.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
}
