//
//  SignUpViewModel.swift
//  Chat App
//
//  Created by Zensar on 15/03/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase
import Photos

class SignUpViewModel: NSObject {

    //MARK: VARIABLES
    lazy var storageRef: FIRStorageReference = FIRStorage.storage().reference(forURL: "gs://secondtry-7e700.appspot.com")// /profilePics
    
    //MARK: METHODS
    func signUpWith(email: String?, password: String?, name: String) {
        guard let email = email, let password = password else {
            return
        }
        FIRAuth.auth()!.createUser(withEmail: email, password: password, completion: { (user, error) in
            guard let user = user else {
                return
            }
            let userModel = User(authData: user, name: name)
            let ref = FIRDatabase.database().reference(withPath: "users")
            let userRef = ref.child(Utils.getUserKeyUsing(email: userModel.email).lowercased())
            
            userRef.setValue(userModel.toAnyObjectUsing())
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password)
        })
    }
    
    func uploadImage(email: String, photoReferenceUrl: URL) {
        
        let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
        let asset = assets.firstObject
        
        asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
            let imageFileURL = contentEditingInput?.fullSizeImageURL
            
            let path = "profilePics/\(email)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)) \(photoReferenceUrl.lastPathComponent)"
            
            self.storageRef.child(path).putFile(imageFileURL!, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading photo: \(error.localizedDescription)")
                    return
                }
                
                print(self.storageRef.child((metadata?.path)!).description)
                let picURL = self.storageRef.child((metadata?.path)!).description
                let ref = FIRDatabase.database().reference(withPath: "users")
                ref.child(Utils.getUserKeyUsing(email: email)).updateChildValues([
                    "profilePicURL": picURL
                    ])
            }
        })
    }
    
}
