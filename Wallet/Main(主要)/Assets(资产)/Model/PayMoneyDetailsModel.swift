//
//  PayMoneyDetailsModel.swift
//  DHSWallet
//
//  Created by tam on 2017/9/5.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import ObjectMapper

class PayMoneyDetailsModel: Mappable{
    
    var SerialNumber: String?
    var cny: Int?
    var money: Int?
    var phone_fu: String?
    var phone_shou: String?
    var sumMoney: Int?
    var sxf: Int?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        SerialNumber          <- map["SerialNumber"]
        cny      <- map["cny"]
        money       <- map["money"]
        phone_fu        <- map["phone_fu"]
        phone_shou             <- map["phone_shou"]
        sumMoney         <- map["sumMoney"]
        sxf                  <- map["sxf"]
    }
}
