//
//  ActiveChatsTableViewCell.swift
//  Chat App
//
//  Created by Zensar on 23/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit

class ActiveChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageViewOnlineStatus: UIImageView!
    @IBOutlet weak var imageViewUnreadMessage: UIImageView!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
