//
//  ManageWalletsCell.swift
//  Wallet
//
//  Created by tam on 2017/8/31.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class ManageWalletsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        firstView.clipsToBounds = true
        firstView.layer.cornerRadius = 10
        
        secondView.clipsToBounds = true
        secondView.layer.cornerRadius = 10
        
        thirdView.clipsToBounds = true
        thirdView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
