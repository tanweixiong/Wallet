//
//  TransactionCoinDetailVw.swift
//  Wallet
//
//  Created by tam on 2017/10/27.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class TransactionCoinDetailVw: UIView {

    @IBOutlet weak var transactionDetailsLabel: UILabel!
    @IBOutlet weak var serialNumberLLabel: UILabel!
    @IBOutlet weak var payeeLLabel: UILabel!
    @IBOutlet weak var transactionTypeLLabel: UILabel!
    @IBOutlet weak var transactionAmountLLabel: UILabel!
    @IBOutlet weak var dataLLabel: UILabel!
    @IBOutlet weak var remarkLLabel: UILabel!
    
    @IBOutlet weak var serialNumberRLabel: UILabel!
    @IBOutlet weak var payeeRLabel: UILabel!
    @IBOutlet weak var transactionTypeRLabel: UILabel!
    @IBOutlet weak var transactionAmountRLabel: UILabel!
    @IBOutlet weak var dataRLabel: UILabel!
    @IBOutlet weak var remarkRLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(MarketModificationView.onClick))
        self.addGestureRecognizer(tap)
        
        transactionDetailsLabel.text = LanguageHelper.getString(key: "transaction_Transaction_Details")
        serialNumberLLabel.text = LanguageHelper.getString(key: "transaction_Serial_Number")
        payeeLLabel.text =  LanguageHelper.getString(key: "transaction_Payee")
        transactionTypeLLabel.text = LanguageHelper.getString(key: "transaction_Transaction_Type")
        transactionAmountLLabel.text = LanguageHelper.getString(key: "transaction_Transaction_Amount")
        dataLLabel.text = LanguageHelper.getString(key: "transaction_data")
        remarkLLabel.text = LanguageHelper.getString(key: "transaction_Remark")
    }
    
    
    func onClick(){
        self.isHidden = true
    }

}
