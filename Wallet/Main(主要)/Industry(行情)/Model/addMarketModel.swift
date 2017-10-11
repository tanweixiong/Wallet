//
//  addMarketModel.swift
//  Wallet
//
//  Created by tam on 2017/9/20.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class addMarketData: Mappable{
    
    var coin_name: String?
    var coin_no: NSNumber?
    var coin_icon: String?
    var market_state: NSNumber?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        coin_name             <- map["coin_name"]
        coin_no               <- map["coin_no"]
        coin_icon             <- map["coin_icon"]
        market_state          <- map["market_state"]
    }
}

class addMarketModel: Mappable {
    
    var code: NSNumber?
    var msg: String?
    var data: [addMarketData]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
}
