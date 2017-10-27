//
//  IndustryListModel.swift
//  Wallet
//
//  Created by tam on 2017/9/12.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class IndustryListData: Mappable{

    var amount: String?
    var cny: CGFloat?
    var coin_name: String?
    var coin_no: NSNumber?
    var limit:   NSNumber?
    var p_high: String?
    var p_last: String?
    var p_open: String?
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

class IndustryListModel: Mappable {
    
    var code: NSNumber?
    var msg: String?
    var data: [IndustryListData]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
}






