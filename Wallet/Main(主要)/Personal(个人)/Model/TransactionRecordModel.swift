//
//  TransactionRecordModel.swift
//  Wallet
//
//  Created by tam on 2017/9/19.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class TransactionRecordData: Mappable{
    
    var change_coin: NSNumber?
    var change_name: String?
    var change_num: NSNumber?
    var coinIcon: String?
    var coin_name: String?
    var coin_no: NSNumber?
    var date: String?
    var fee: NSNumber?
    var id: NSNumber?
    var num: NSNumber?
    var remark: String?
    var user_id: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        change_coin            <- map["change_coin"]
        change_name            <- map["change_name"]
        change_num             <- map["change_num"]
        coinIcon               <- map["coinIcon"]
        coin_name              <- map["coin_name"]
        coin_no                <- map["coin_no"]
        date                   <- map["date"]
        fee                    <- map["fee"]
        id                     <- map["id"]
        num                    <- map["num"]
        remark                 <- map["remark"]
        user_id                <- map["user_id"]
    }
}

class TransactionRecordModel: Mappable {
    
    var code: String?
    var msg: String?
    var data: [TransactionRecordData]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
}
