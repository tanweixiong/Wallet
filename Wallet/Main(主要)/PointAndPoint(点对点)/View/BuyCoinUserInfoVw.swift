//
//  BuyCoinUserInfoVw.swift
//  Wallet
//
//  Created by tam on 2017/10/9.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class BuyCoinUserInfoVw: UIView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var numTransactionsLabel: UILabel!
    @IBOutlet weak var numTrustsLabel: UILabel!
    @IBOutlet weak var numPraiseLabel: UILabel!
    @IBOutlet weak var numHistoryLabel: UILabel!
    @IBOutlet weak var buyCurrencyLabel: UILabel!
    @IBOutlet weak var purchaseQuantityLabel: UILabel!
    @IBOutlet weak var sellTheCurrencyLabel: UILabel!
    @IBOutlet weak var numSoldLabel: UILabel!
 
    var dataModel:BuyCoinModel = BuyCoinModel(){
        didSet {
            
        }
    }
    
    var moreBtnOnClickClosure:((_ dataModel: BuyCoinModel) -> Void)?
    func MoreBtnOnClickClosure(_ closure: ((_ dataModel: BuyCoinModel) -> Void)?) {
        moreBtnOnClickClosure = closure
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
