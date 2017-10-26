//
//  MineBusinessView.swift
//  Wallet
//
//  Created by tam on 2017/10/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class MineBusinessView: UIView {
    var mineBusinessCallBack:((UIButton)->())?;
    var businessDatilCallBack:((UIButton)->())?;
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var codeAvatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        modifyButton.setTitle(LanguageHelper.getString(key: "card_modify"), for: .normal)
    }
    
    @IBAction func modifyClick(_ sender: UIButton) {
        if mineBusinessCallBack != nil {
            mineBusinessCallBack!(modifyButton)
        }
    }
    
    @IBAction func businessDetailClick(_ sender: UIButton) {
        if businessDatilCallBack != nil {
           businessDatilCallBack!(detailBtn)
        }
    }
}
