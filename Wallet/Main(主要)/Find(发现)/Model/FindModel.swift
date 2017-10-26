//
//  FindModel.swift
//  Wallet
//
//  Created by tam on 2017/10/26.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class FindDetailModel: Mappable{
    
    var id: String?
    var news_title: String?
    var news_text: String?
    var createTime: String?
    var admin_id: String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        id            <- map["id"]
        news_title    <- map["news_title"]
        news_text     <- map["news_text"]
        createTime    <- map["createTime"]
        admin_id      <- map["admin_id"]
    }
}

class FindModel: Mappable {
    
    var code: NSNumber?
    var msg: String?
    var data: [FindDetailModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
}
