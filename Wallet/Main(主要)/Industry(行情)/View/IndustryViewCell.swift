//
//  IndustryViewCell.swift
//  Wallet
//
//  Created by tam on 2017/8/25.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class IndustryViewCell: UITableViewCell {
    
    @IBOutlet weak var coin_nameLabel: UILabel!
    
    @IBOutlet weak var cnyLabel: UILabel!
    
    @IBOutlet weak var usdLabel: UILabel!
    
    @IBOutlet weak var limitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        limitLabel.clipsToBounds = true
        limitLabel.layer.cornerRadius =  5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
