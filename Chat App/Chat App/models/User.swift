//
//  User.swift
//  Chat App
//
//  Created by Zensar on 22/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

struct User {
    static var currentUser: User?
    
    let uid: String
    let email: String
    var isOnline: Bool?
    var name: String
    var profilePicURL: String = "NoPic"
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
        name = ""
    }
    
    init(authData: FIRUser, name: String) {
        uid = authData.uid
        email = authData.email!
        self.name = name
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
        name = ""
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        email = snapshotValue["email"] as! String
        uid = snapshotValue["uid"] as! String
        isOnline = snapshotValue["online"] as? Bool
        name = snapshotValue["name"] as! String
    }

    
    func toAnyObjectUsing() -> Any {
        return [
            "uid": uid,
            "email": email,
            "online": false,
            "name": name,
            "profilePicURL": profilePicURL
        ]
    }
}
