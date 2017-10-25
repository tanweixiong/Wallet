//
//  AddMineBusinessCardCell.swift
//  Wallet
//
//  Created by tam on 2017/10/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class AddMineBusinessCardCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.setValue(UIColor.R_UIRGBColor(red: 207, green: 207, blue: 207, alpha: 1), forKeyPath: "_placeholderLabel.textColor")
        textField.textAlignment = .right;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
