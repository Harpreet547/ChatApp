//
//  Chat.swift
//  Chat App
//
//  Created by Zensar on 23/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

struct Chat {
    let firstUser: String?
    let secondUser: String?
    let messages: [Messages] = [Messages]()
    
    init(firstUser: String, secondUser: String) {
        self.firstUser = firstUser
        self.secondUser = secondUser
    }
    
    func toAnyObject() -> Any {
        return [
            "firstUser": firstUser ?? "default",
            "secondUser": secondUser ?? "default",
        ]
    }
}

struct Messages {
    let from: String?
    let to: String?
    let message: String?
    
    init(from: String, to: String, message: String) {
        self.from = from
        self.to = to
        self.message = message
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        to = snapshotValue["to"] as? String
        from = snapshotValue["from"] as? String
        message = snapshotValue["message"] as? String
    }
    
    func toAnyObject() -> Any {
        return [
            "from": from,
            "to": to,
            "message": message
        ]
    }
}
