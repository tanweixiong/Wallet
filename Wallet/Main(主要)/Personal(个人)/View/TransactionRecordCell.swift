//
//  TransactionRecordCell.swift
//  Wallet
//
//  Created by tam on 2017/8/31.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class TransactionRecordCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var transactionLabel: UILabel!
    
    @IBOutlet weak var backgroundVw: UIView!
    
    @IBOutlet weak var coinIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundVw.layer.cornerRadius = 5
        backgroundVw.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
