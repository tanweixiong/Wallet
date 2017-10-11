//
//  SalesCoinCell.swift
//  Wallet
//
//  Created by tam on 2017/10/9.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class SalesCoinCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var praiseLabel: UILabel!
    @IBOutlet weak var trustLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var buyHandleButton: UIButton!
    
    var salesCoinBlock:((UIButton)->())?;
    
    var dataModel: SalesCoinModel = SalesCoinModel() {
        didSet {
            transactionLabel.text = "·" + "交易" + "4"
            praiseLabel.text = "·" + "好评" + "4"
            trustLabel.text = "·" + "信任" + "4"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buyHandleButton.layer.borderColor = UIColor.R_UIRGBColor(red: 240, green: 238, blue: 238, alpha: 1).cgColor
    }
    
    @IBAction func buyHandle(_ sender: UIButton) {
        if  self.salesCoinBlock != nil {
            self.salesCoinBlock!(sender)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
