//
//  ChatViewModel.swift
//  Chat App
//
//  Created by Zensar on 23/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

class ChatViewModel: NSObject {
    
    //MARK: Variables
    var selectedUser: User?
    var isChatOpenedBySelectedUser: Bool = false
    var messages: [Messages] = [Messages]()
    var databaseRefArray: [FIRDatabaseReference] = [FIRDatabaseReference]() //Store database ref in this array to remove their observers in the end
    
    //MARK: Methods
    func searchOrCreateChat() {
        let chatKey = Utils.getChatKey(selectedUserEmail: self.selectedUser!.email)
        
        let ref = FIRDatabase.database().reference(withPath: "chats")
        databaseRefArray.append(ref)
        ref.queryOrderedByKey().queryEqual(toValue: chatKey).observe(.value, with: {[unowned self] (snap) in
            
            if Int(snap.childrenCount.description) == 0 {
                let chatRef = ref.child(chatKey.lowercased())
                chatRef.setValue(Chat(firstUser: User.currentUser!.email, secondUser: self.selectedUser!.email).toAnyObject())
                
                let usersRef = FIRDatabase.database().reference(withPath: "users")
                let currentUserRef = usersRef.child(Utils.getUserKeyUsing(email: User.currentUser!.email))
                
                let userChatRef = currentUserRef.child("chats").child(Utils.getChatKey(selectedUserEmail: self.selectedUser!.email))
                userChatRef.setValue([
                    "secondUser": self.selectedUser!.email,
                    "hasUnreadMessages": false
                    ])
            
                let secondUserRef = usersRef.child(Utils.getUserKeyUsing(email: self.selectedUser!.email))
                let secondUserChatRef = secondUserRef.child("chats").child(Utils.getChatKey(selectedUserEmail: self.selectedUser!.email))
                secondUserChatRef.setValue([
                    "secondUser": User.currentUser!.email,
                    "hasUnreadMessages": false
                    ])
            }else {
                let userRef = FIRDatabase.database().reference(withPath: "users").child(Utils.getUserKeyUsing(email: User.currentUser!.email))
                let userChatRef = userRef.child("chats").child(Utils.getChatKey(selectedUserEmail: self.selectedUser!.email))
                userChatRef.updateChildValues([
                    "hasUnreadMessages": false,
                    "isOpened": true
                    ])

            }
        })
        
    }
    
    func observeOnlineStatusOfSelectedUser() {
        let allUsersRef = FIRDatabase.database().reference(withPath: "users")
        let selectedUserChatRef = allUsersRef.child(Utils.getUserKeyUsing(email: selectedUser!.email)).child("chats").child(Utils.getChatKey(selectedUserEmail: self.selectedUser!.email))
        databaseRefArray.append(selectedUserChatRef)
        selectedUserChatRef.queryOrderedByKey().queryEqual(toValue: "isOpened").observe(.value, with: {[unowned self] (snap) in
            print(snap)
            if let value = snap.value as? [String: AnyObject] {
                self.isChatOpenedBySelectedUser = value["isOpened"] as! Bool
            }
            
        })
    }
    
    
    func updateMessage(completionHandler: @escaping () -> Void) {
        let ref = FIRDatabase.database().reference(withPath: "chats")
        databaseRefArray.append(ref)
        let chatKey = Utils.getChatKey(selectedUserEmail: self.selectedUser!.email)
        let chatref = ref.child(chatKey)
        let messageRef = chatref.child("messages")
        databaseRefArray.append(messageRef)
        messageRef.observe(.childAdded, with: {[unowned self] (snap) in
            self.messages.append(Messages(snapshot: snap))
            completionHandler()
        })
        
    }
    
    func sendMessage(message: String) {
        let ref = FIRDatabase.database().reference(withPath: "chats")
        databaseRefArray.append(ref)
        let chatKey = Utils.getChatKey(selectedUserEmail: self.selectedUser!.email)
        let chatref = ref.child(chatKey)
        let message = Messages(from: User.currentUser!.email, to: selectedUser!.email, message: message)
        let messageRef = chatref.child("messages").childByAutoId()
        messageRef.setValue(message.toAnyObject())
        
        if !isChatOpenedBySelectedUser {
            let secondUserRef = FIRDatabase.database().reference(withPath: "users").child(Utils.getUserKeyUsing(email: selectedUser!.email))
            let userChatRef = secondUserRef.child("chats").child(Utils.getChatKey(selectedUserEmail: self.selectedUser!.email))
            userChatRef.updateChildValues([
                    "hasUnreadMessages": true
                ])
        }
    }
    
    func removeAllObservers() {
        let userRef = FIRDatabase.database().reference(withPath: "users").child(Utils.getUserKeyUsing(email: User.currentUser!.email))
        let userChatRef = userRef.child("chats").child(Utils.getChatKey(selectedUserEmail: self.selectedUser!.email))
        userChatRef.updateChildValues([
            "isOpened": false
            ])

        for ref in databaseRefArray {
            ref.removeAllObservers()
        }

    }
}
