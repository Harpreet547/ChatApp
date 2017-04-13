//
//  SearchBarViewModel.swift
//  Chat App
//
//  Created by Zensar on 22/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

class SearchBarViewModel: NSObject {
    var filteredUsers: [User] = [User]()
    
    override init() {
        super.init()
    }
    
    //MARK: SearchBar helper methods
    func searchUserOnServerUsing(searchText text: String, completionHandler: @escaping () -> Void) {
        let ref = FIRDatabase.database().reference(withPath: "users")
        ref.queryOrdered(byChild: "email").queryEqual(toValue: text.lowercased()).observe(.value, with: {[unowned self] (snap) in
            var users: [User] = [User]()
            print(snap.childrenCount.description)
            for item in snap.children {
                print(item);
                let user = User(snapshot: item as! FIRDataSnapshot)
                if user.email != User.currentUser?.email {
                    users.append(user)
                }
                
            }
            self.filteredUsers = users
            completionHandler()
        })
    }
    
    //MARK: TableView Helper methods
    func returnEmptyView() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 1)
        return UIView(frame: frame)
    }
}
