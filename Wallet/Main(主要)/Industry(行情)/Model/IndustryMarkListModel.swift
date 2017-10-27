//
//  IndustryMarkListModel.swift
//  Wallet
//
//  Created by tam on 2017/9/12.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class IndustryMarkListdata: Mappable{
    
    var amount: NSNumber?
    var cny: CGFloat?
    var coin_name: String?
    var coin_no: NSNumber?
    var limit:   NSNumber?
    var p_high: NSNumber?
    var p_last: NSNumber?
    var p_open: NSNumber?
    var uporlow: NSNumber?
    var usd: CGFloat?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        amount                <- map["amount"]
        cny                   <- map["cny"]
        coin_name             <- map["coin_name"]
        coin_no               <- map["coin_no"]
        limit                 <- map["limit"]
        p_high                <- map["p_high"]
        p_last                <- map["p_last"]
        p_open                <- map["p_open"]
        uporlow               <- map["uporlow"]
        usd                   <- map["usd"]
    }
}

class IndustryMarkListModel: Mappable {
    
    var code: NSNumber?
    var msg: String?
    var data: IndustryMarkListdata?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
}
