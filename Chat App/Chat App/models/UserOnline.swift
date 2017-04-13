//
//  UsersOnline.swift
//  Chat App
//
//  Created by Zensar on 02/03/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit

struct ActiveChatDetails {
    let email: String
    var isOnline: Bool?
    var hasUnreadMessages: Bool?
    var name: String
    var image = UIImage(named: "profilePic")
    
    init(email: String, isOnline: Bool) {
        self.isOnline = isOnline
        self.email = email
        self.name = ""
    }
}
