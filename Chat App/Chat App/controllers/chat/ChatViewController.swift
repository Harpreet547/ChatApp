//
//  ChatViewController.swift
//  Chat App
//
//  Created by Zensar on 23/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    //MARK: Variables
    let viewModel = ChatViewModel()
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.selectedUser?.name
        
        tableView.estimatedRowHeight = 54
        tableView.rowHeight = UITableViewAutomaticDimension
        
        viewModel.searchOrCreateChat()
        viewModel.observeOnlineStatusOfSelectedUser()
        viewModel.updateMessage(completionHandler: {[unowned self] in
            self.tableView.reloadData()
            let indexPath = IndexPath(item: self.viewModel.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.removeAllObservers()
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        viewModel.sendMessage(message: textField.text!)
        textField.text = ""
        tableView.reloadData()
        
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCellTableViewCell
        
        cell.label.text = viewModel.messages[indexPath.row].message
        let from = viewModel.messages[indexPath.row].from
        if from == User.currentUser?.email {
            cell.label.textAlignment = .right
        }else {
            cell.label.textAlignment = .left
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
