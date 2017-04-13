//
//  AppConstans.swift
//  Chat App
//
//  Created by Zensar on 17/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit

struct AppConstants {
    enum StoryboardIdentifiers: String {
        case LoginViewController
        case ChatsViewController
        case ChatNavController //Base Navigation controller for chats VC
    }
    
    struct colorTheme {
        static let mainColor = UIColor(netHex: 0x984B43)
        static let primaryColor = UIColor(netHex: 0x008F95)
        static let secondaryColor = UIColor(netHex: 0x233237)
    }
    
}
