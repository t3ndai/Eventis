//
//  userCommentTableViewCell.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 7/20/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit

class userCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var userComment: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
