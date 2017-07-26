//
//  MyNotificationCell.swift
//  EZGuitar
//
//  Created by CheckoutUser on 7/17/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import UIKit

class MyNotificationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextDateLabel: UILabel!
    @IBOutlet weak var nextTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
