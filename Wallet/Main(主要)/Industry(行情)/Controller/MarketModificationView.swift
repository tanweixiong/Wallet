//
//  MarketModificationView.swift
//  Wallet
//
//  Created by tam on 2017/9/20.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class MarketModificationView: UIView {

    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var addMyMarket: UIButton!
    @IBOutlet weak var editMyMarket: UIButton!
    
    @IBOutlet weak var addMyMarketLabel: UILabel!
    @IBOutlet weak var editMyMarketLabel: UILabel!
    
    var marketModificationBlock:((UIButton)->())?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(MarketModificationView.onClick))
        self.addGestureRecognizer(tap)
        
        addMyMarketLabel.text = LanguageHelper.getString(key: "add_markets")
        editMyMarketLabel.text = LanguageHelper.getString(key: "edit_markets")
    }
    
    func onClick(){
        self.isHidden = true
    }
    
    @IBAction func addMarket(_ sender: UIButton) {
        self.isHidden = true
        if marketModificationBlock != nil {
            marketModificationBlock!(sender)
        }
    }

    @IBAction func editMarket(_ sender: UIButton){
        self.isHidden = true
        if marketModificationBlock != nil {
            marketModificationBlock!(sender)
        }
    }
}
