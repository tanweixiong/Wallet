
//
//  PersonalHeadCell.swift
//  Wallet
//
//  Created by tam on 2017/8/25.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class PersonalHeadCell: UITableViewCell {
    
    @IBOutlet weak var manageWalletsLabel: UILabel!
    
    @IBOutlet weak var transactionRecordLabel: UILabel!
  
    var manageWalletBlock:((UIButton)->())?;
    
    @IBAction func manageWalletOnClick(_ sender: UIButton) {
        if self.manageWalletBlock != nil {
            self.manageWalletBlock!(sender);
        }
    }
    
    @IBAction func transactionOnClick(_ sender: UIButton) {
        if self.manageWalletBlock != nil {
            self.manageWalletBlock!(sender);
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        manageWalletsLabel.text = LanguageHelper.getString(key: "manage_wallet")
        transactionRecordLabel.text = LanguageHelper.getString(key: "trade")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
