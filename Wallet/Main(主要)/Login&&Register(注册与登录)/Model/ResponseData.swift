//
//  ResponseData.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/22.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import ObjectMapper

class ResponseData: Mappable {
    
    var code: Int?
    var msg: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        
    }
}
