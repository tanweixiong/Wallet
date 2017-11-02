//
//  BusinessCardHeadCell.swift
//  Wallet
//
//  Created by tam on 2017/10/25.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessCardHeadCell: UITableViewCell {
   var businessCardHeadCallBack:(()->())?;
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func addImageClick(_ sender: UIButton) {
        if businessCardHeadCallBack != nil {
            businessCardHeadCallBack!()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
