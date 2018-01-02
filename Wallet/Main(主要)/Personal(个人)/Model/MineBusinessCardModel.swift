//
//  MineBusinessCardModel.swift
//  Wallet
//
//  Created by tam on 2017/10/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class MineBusinessCardData: Mappable{
    
    var job: String?
    var name: String?
    var email: String?
    var wechat: String?
    var phone: String?
    var alipay: String?
    var id: String?
    var user_id: String?
    var photo: String?
    var address: String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        job = ""
        name = ""
        email = ""
        wechat = ""
        phone = ""
        alipay = ""
        id = ""
        user_id = ""
        photo = ""
        address = ""
    }
    
    func mapping(map: Map) {
        job            <- map["job"]
        name           <- map["name"]
        email          <- map["email"]
        wechat         <- map["wechat"]
        phone          <- map["phone"]
        alipay         <- map["alipay"]
        id             <- map["id"]
        user_id        <- map["user_id"]
        photo          <- map["photo"]
        address        <- map["address"]
    }
}

class MineBusinessCardModel: Mappable {
    
    var code: Int?
    var msg: String?
    var data: [MineBusinessCardData]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
}
