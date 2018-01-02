//
//  TransactionCoinCell.swift
//  Wallet
//
//  Created by tam on 2017/9/14.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class TransactionCoinCell: UITableViewCell {

    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
