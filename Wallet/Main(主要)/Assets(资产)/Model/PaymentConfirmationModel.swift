//
//  PaymentConfirmationModel.swift
//  DHSWallet
//
//  Created by tam on 2017/9/6.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentConfirmationModel: Mappable {
    
    var code: String?
    var msg: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        
    }
}
