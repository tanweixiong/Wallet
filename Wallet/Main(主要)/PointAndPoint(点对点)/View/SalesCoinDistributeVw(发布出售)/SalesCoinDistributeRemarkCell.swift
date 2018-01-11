//
//  SalesCoinDistributeRemarkCell.swift
//  Wallet
//
//  Created by tam on 2018/1/9.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import YYText

class SalesCoinDistributeRemarkCell: UITableViewCell,YYTextViewDelegate {
    @IBOutlet weak var ramarkLabel: UILabel!
    fileprivate let textViewHeight:CGFloat = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(){
        contentView.addSubview(textView!)
        textView?.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(ramarkLabel.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.height.equalTo(textViewHeight)
        })
        UserDefaults.standard.set(ramarkLabel.frame.maxY + textViewHeight + 20, forKey: "height")
    }
    
    lazy var textView:YYTextView? = {
        let view = YYTextView.init(frame: CGRect.init(x: 0, y: 0, width:0, height: 0))
        view.placeholderText = "留言，请说明有关您交易的相关条款或备注您的支付方式。"
        view.placeholderFont = UIFont.systemFont(ofSize: 14)
        view.placeholderTextColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 14)
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: self.textViewHeight)
        view.layer.masksToBounds = true
        return view
    }()
    
}
