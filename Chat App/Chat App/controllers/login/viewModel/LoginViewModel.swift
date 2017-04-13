//
//  LoginViewModel.swift
//  Chat App
//
//  Created by Zensar on 17/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewModel: NSObject {

    func checkUserAuthStatus() {
        FIRAuth.auth()?.addStateDidChangeListener({ (aurh, user) in
            if let user = user {
                User.currentUser = User(authData: user)
                let userRef = FIRDatabase.database().reference(withPath: "users").child(Utils.getUserKeyUsing(email: User.currentUser!.email))
                userRef.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                    if let value = snap.value as? [String: AnyObject] {
                        User.currentUser!.name = value["name"] as! String
                    }
                })
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.showChatsScreen()
            }
        })
    }
    
    func authUser(with email: String?, password: String?) {
        guard let email = email, let password = password else {
            Utils.showAlert(with: "Unable to login", message: "Please enter missing fields")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            guard let _ = user else {
                Utils.showAlert(with: "Unable to login", message: "Invalid Credentials")
                return
            }
            
            
        })
    }
    
    func signUpWith(email: String?, password: String?) {
        guard let email = email, let password = password else {
            return
        }
        FIRAuth.auth()!.createUser(withEmail: email, password: password, completion: { (user, error) in
            guard let user = user else {
                return
            }
            let userModel = User(authData: user)
            let ref = FIRDatabase.database().reference(withPath: "users")
            let userRef = ref.child(Utils.getUserKeyUsing(email: userModel.email).lowercased())
            
            userRef.setValue(userModel.toAnyObjectUsing())
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password)
        })
    }
    
    
}
