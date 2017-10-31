//
//  CreateMyWalletBar.swift
//  Wallet
//
//  Created by tam on 2017/10/31.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class CreateMyWalletBar: UIView {
    var createMyWalletBarCallBack:((UIButton)->())?;
    
    @IBOutlet weak var phoneRegistrationBtn: UIButton!
    @IBOutlet weak var mallRegistrationBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        if sender.tag == 1 {
            phoneRegistrationBtn.isSelected = true
            phoneRegistrationBtn.backgroundColor = R_UIThemeColor
            mallRegistrationBtn.isSelected = false
            mallRegistrationBtn.backgroundColor = UIColor.white
            
        }else{
            phoneRegistrationBtn.isSelected = false
            phoneRegistrationBtn.backgroundColor = UIColor.white
            mallRegistrationBtn.isSelected = true
            mallRegistrationBtn.backgroundColor = R_UIThemeColor
        }
        if createMyWalletBarCallBack != nil {
            createMyWalletBarCallBack!(sender)
        }
    }
}
