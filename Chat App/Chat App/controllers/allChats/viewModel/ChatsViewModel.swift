//
//  ChatsViewModel.swift
//  Chat App
//
//  Created by Zensar on 23/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

class ChatsViewModel: NSObject {
    
    var selectedUser: User?
    var activeChatUsers: [ActiveChatDetails] = [ActiveChatDetails]()
    var delegate: ChangeOnlineStatusOfChatsDelegate? = nil
    
    
    func findActiveChats() {
        let ref = FIRDatabase.database().reference(withPath: "users")
        ref.keepSynced(true)
        let userRef = ref.child(Utils.getUserKeyUsing(email: User.currentUser!.email))
        
        let userChatsRef = userRef.child("chats")
        userChatsRef.queryOrderedByKey().observeSingleEvent(of: .value, with: {[unowned self] (snap) in
            for item in snap.children {
                let snapShot = item as! FIRDataSnapshot
                let value = snapShot.value as! [String: AnyObject]
                
                var userOnline = ActiveChatDetails(email: value["secondUser"] as! String, isOnline: false)
                ref.child(Utils.getUserKeyUsing(email: userOnline.email)).queryOrderedByKey().queryEqual(toValue: "name").observeSingleEvent(of: .value, with: { (snap) in
                    let value = snap.value as! [String: AnyObject]
                    userOnline.name = value["name"] as! String
                    self.activeChatUsers.append(userOnline)
                    self.delegate?.prepareOnlineStatusOfChats()
                    
                })
                
            }
            //for profile pics
            var index = 0
            for item in snap.children {
                let snapShot = item as! FIRDataSnapshot
                let value = snapShot.value as! [String: AnyObject]
                let userKeyForProfilePic = Utils.getUserKeyUsing(email: value["secondUser"] as! String)
                
                ref.child(userKeyForProfilePic).queryOrderedByKey().queryEqual(toValue: "profilePicURL").observeSingleEvent(of: .value, with: { (snap) in
                    let value = snap.value as! [String: AnyObject]
                    self.fetchImageDataAtURL(value["profilePicURL"] as! String, index: index)
                    index += 1
                })
                
            }
        })
    }
    
    func getOnlineStatusForChats() {
        let ref = FIRDatabase.database().reference(withPath: "users")
        
        for userOnline in activeChatUsers {
            let userRef = ref.child(Utils.getUserKeyUsing(email: userOnline.email))
            userRef.queryOrderedByKey().observeSingleEvent(of: .value, with: {[unowned self] (snap) in
                print(snap)
                let value = snap.value as! [String: AnyObject]
                let isOnline = value["online"] as? Bool
                for (index, user) in self.activeChatUsers.enumerated() {
                    if Utils.getUserKeyUsing(email: user.email) == snap.ref.key {
                        self.activeChatUsers[index].isOnline = isOnline
                        self.delegate?.tableViewUpdate(index: index)
                    }
                }
            })
            
        }
    }
    
    func updateOnlineStatusForChats() {
        let ref = FIRDatabase.database().reference(withPath: "users")
        
        for userOnline in self.activeChatUsers {
            ref.child(Utils.getUserKeyUsing(email: userOnline.email)).observe(.value, with: { (snap) in
                let value = snap.value as! [String: AnyObject]
                let isOnline = value["online"] as! Bool
                for (index, user) in self.activeChatUsers.enumerated() {
                    if Utils.getUserKeyUsing(email: user.email) == snap.key {
                        self.activeChatUsers[index].isOnline = isOnline
                        self.delegate?.tableViewUpdate(index: index)
                    }
                }
            })
        }
    }
    
    func checkForUnreadMessages() {
        let ref = FIRDatabase.database().reference(withPath: "users")
        
        for activeChatUser in self.activeChatUsers {
            let chatKey = Utils.getChatKey(selectedUserEmail: activeChatUser.email)
            ref.child(Utils.getUserKeyUsing(email: User.currentUser!.email)).child("chats").child(chatKey).observe(.value, with: { (snap) in
                print("Checking unread Messages")
                print(snap)
                print("Checking unread messages ends")
                let value = snap.value as! [String: AnyObject]
                
                for (index, user) in self.activeChatUsers.enumerated() {
                    if user.email == value["secondUser"] as! String {
                        self.activeChatUsers[index].hasUnreadMessages = value["hasUnreadMessages"] as? Bool
                        self.delegate?.tableViewUpdate(index: index)
                    }
                }
            })
        }
    }
    
    func getEmptyView() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        return UIView(frame: frame)
    }
    
    func getUserFromEmail(email: String, completionHandler: @escaping (_ user: User?) -> Void) {
        let ref = FIRDatabase.database().reference(withPath: "users")
        ref.keepSynced(true)
        ref.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (snap) in
            var user: User?
            for item in snap.0.children {
                user = User(snapshot: item as! FIRDataSnapshot)
            }
            completionHandler(user)
        })
    }
    
    func fetchImageDataAtURL(_ photoURL: String, index: Int) {
        print(index)
        var mediaItem: UIImage?
        let storageRef = FIRStorage.storage().reference(forURL: photoURL)
        
        storageRef.data(withMaxSize: INT64_MAX){[unowned self] (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            storageRef.metadata(completion: {[unowned self] (metadata, metadataErr) in
                
                if let error = metadataErr {
                    print("Error downloading metadata: \(error)")
                    return
                }
                
                if let data = data {
                    if (metadata?.contentType == "image/gif") {
                        mediaItem = UIImage.gif(data: data)
                    } else {
                        mediaItem = UIImage(data: data)
                        print("Data got")
                        print(index)
                    }
                }
                
                self.activeChatUsers[index].image = mediaItem
                self.delegate?.reloadTable()
            })
        }
    }
}
