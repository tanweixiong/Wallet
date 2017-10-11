//
//  SystemSettingsCell.swift
//  Wallet
//
//  Created by tam on 2017/9/1.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class SystemSettingsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var backgroundVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundVw.layer.cornerRadius = 5
        backgroundVw.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
