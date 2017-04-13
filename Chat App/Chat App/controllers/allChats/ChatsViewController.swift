//
//  ChatsViewController.swift
//  Chat App
//
//  Created by Zensar on 17/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

protocol ChangeOnlineStatusOfChatsDelegate {
    func tableViewUpdate(index: Int)
    func prepareOnlineStatusOfChats()
    func reloadTable()
}

class ChatsViewController: UIViewController, ChangeOnlineStatusOfChatsDelegate {

    //MARK: Variables
    let viewModel = ChatsViewModel()
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        applyAppTheme()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setUserOnlineStatus(status: true)
        self.tableView.tableFooterView = viewModel.getEmptyView()
        viewModel.findActiveChats()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func applyAppTheme() {
        self.title = "Chats"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = AppConstants.colorTheme.primaryColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    //MARK: IBOutlets
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setUserOnlineStatus(status: false)
            appDelegate.showLoginScreen()
        }catch {
            
        }
    }
    
    //MARK: ChangeOnlineStatusOfChatsDelegate
    func tableViewUpdate(index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? ActiveChatsTableViewCell
        if let cell = cell {
            self.tableView.beginUpdates()
            
            var status = "offline"
            if viewModel.activeChatUsers[index].isOnline! {
                status = "online"
            }
            cell.imageViewOnlineStatus.image = UIImage(named: status)
            cell.imageViewUnreadMessage.isHidden = true
            if let hasUnreadMessages = viewModel.activeChatUsers[index].hasUnreadMessages {
                cell.imageViewUnreadMessage.isHidden = !hasUnreadMessages
            }
            
            self.tableView.endUpdates()
        }
    }
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func prepareOnlineStatusOfChats() {
        self.tableView.reloadData()
        self.viewModel.getOnlineStatusForChats()
        self.viewModel.updateOnlineStatusForChats()
        self.viewModel.checkForUnreadMessages()
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.activeChatUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeChatsCell") as! ActiveChatsTableViewCell
        let activeChat = viewModel.activeChatUsers[indexPath.row]
        
        cell.label.text = activeChat.name
        
        var onlineStatus = "offline"
        if activeChat.isOnline! {
            onlineStatus = "online"
        }
        cell.imageViewProfilePic.layer.cornerRadius = cell.imageViewProfilePic.frame.size.height / 2
        cell.imageViewProfilePic.image = activeChat.image
        cell.imageViewProfilePic.clipsToBounds = true
        cell.imageViewOnlineStatus.image = UIImage(named: onlineStatus)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.getUserFromEmail(email: viewModel.activeChatUsers[indexPath.row].email, completionHandler: {[unowned self] (user) in
            if let user = user {
                self.viewModel.selectedUser = user
                self.performSegue(withIdentifier: segueIdentiers.chatSegue.rawValue, sender: self)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


extension ChatsViewController: SearchResultDelegate {
    func searchResult(user: User) {
        viewModel.selectedUser = user
        performSegue(withIdentifier: segueIdentiers.chatSegue.rawValue, sender: self)
    }
}

extension ChatsViewController {
    enum segueIdentiers: String {
        case searchSegue
        case chatSegue
    }
    
    //MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case segueIdentiers.searchSegue.rawValue:
            let destVC = segue.destination as! SearchUsersViewController
            destVC.delegate = self
            break
            
        case segueIdentiers.chatSegue.rawValue:
            let destVC = segue.destination as! ChatViewController
            destVC.viewModel.selectedUser = viewModel.selectedUser
            break
            
        default:
            break
        }
    }
}
