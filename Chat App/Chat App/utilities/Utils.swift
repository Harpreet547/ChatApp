//
//  Utils.swift
//  Chat App
//
//  Created by Zensar on 20/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

class Utils: NSObject {
    
    static func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        if let vc = getTopVC() {
            vc.present(alert, animated: true, completion: nil)
        }
        
    }
    
    static func getTopVC() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    private static func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }

    static func getUserKeyUsing(email: String) -> String {
        return Utils.removeSpecialCharsFromString(text: email)
    }
    
    static func getChatKey(selectedUserEmail: String) -> String {
        let currentUserKey = getUserKeyUsing(email: User.currentUser!.email)
        let selectedUserKey = getUserKeyUsing(email: selectedUserEmail)
        var userKeys = [selectedUserKey, currentUserKey]
        userKeys = userKeys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        let chatKey = userKeys[0] + userKeys[1]
        return chatKey
    }
    
}
