//
//  HostUpdateTableViewCell.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 7/25/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit

class HostUpdateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var hostUpdate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
