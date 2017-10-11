//
//  CurrencyConversionCell.swift
//  Wallet
//
//  Created by tam on 2017/9/13.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class CurrencyConversionCell: UITableViewCell {

    @IBOutlet weak var conversionButton: UIButton!
    
    @IBOutlet weak var coin_name: UILabel!
    
    @IBOutlet weak var backgroundVw: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var currencyConversionBlock:((UIButton)->())?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundVw.clipsToBounds = true
        backgroundVw.layer.cornerRadius = 8
        
        conversionButton.layer.cornerRadius = 16
        conversionButton.clipsToBounds = true
    }

    @IBAction func ConversionOnClick(_ sender: UIButton) {
        if self.currencyConversionBlock != nil {
            self.currencyConversionBlock!(sender);
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
