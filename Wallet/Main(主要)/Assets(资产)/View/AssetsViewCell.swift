//
//  AssetsViewCell.swift
//  Wallet
//
//  Created by tam on 2017/8/24.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class AssetsViewCell: UITableViewCell {

    @IBOutlet weak var sumMoneyLabel: UILabel!
    @IBOutlet weak var allMoneyLabel: UILabel!

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var transformationButton: UIButton!
    
    @IBOutlet weak var icon_nameLabel: UILabel!

    var transformationBlock:((UIButton)->())?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        transformationButton.layer.borderWidth = 1
        transformationButton.layer.cornerRadius = 16
        transformationButton.clipsToBounds = true
        transformationButton.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xdddddd).cgColor
        
        self.createUI()
    }
    
    
    @IBAction func transformationOnClick(_ sender: UIButton) {
        transformationButton.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xdddddd).cgColor
        if transformationBlock != nil {
            transformationBlock!(sender)
        }
    }

    @IBAction func transformationHighlightOnClick(_ sender: Any) {
        transformationButton.layer.borderColor = UIColor.clear.cgColor
    }

    func createUI(){
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
