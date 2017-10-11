//
//  PayMoneyModel.swift
//  DHSWallet
//
//  Created by tam on 2017/9/5.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import ObjectMapper

class PayMoneyModel: Mappable {
    
    var code: String?
    var msg: String?
    var data: PayMoneyDetailsModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
        
    }
}
