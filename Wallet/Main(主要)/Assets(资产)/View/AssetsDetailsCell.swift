//
//  AssetsDetailsCell.swift
//  Wallet
//
//  Created by tam on 2017/9/11.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class AssetsDetailsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var coinSwitch: UISwitch!
    
    @IBOutlet weak var backgroundvw: UIView!
    
    var assetsDetailsBlock:((UISwitch)->())?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundvw.clipsToBounds = true
        backgroundvw.layer.cornerRadius = 8
    }
    
    @IBAction func coinSwitchClick(_ sender: UISwitch) {
        if self.assetsDetailsBlock != nil {
            self.assetsDetailsBlock!(sender);
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
