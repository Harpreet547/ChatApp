//
//  ChatCellTableViewCell.swift
//  Chat App
//
//  Created by Zensar on 23/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit

class ChatCellTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
