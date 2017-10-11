//
//  addMarketCell.swift
//  Wallet
//
//  Created by tam on 2017/9/20.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class addMarketCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var coinSwitch: UISwitch!
    
    var addMarketBlock:((UISwitch)->())?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func OnClick(_ sender: UISwitch) {
        if self.addMarketBlock != nil {
            self.addMarketBlock!(sender);
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
