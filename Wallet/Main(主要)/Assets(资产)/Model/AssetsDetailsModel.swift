//
//  AssetsDetailsModel.swift
//  Wallet
//
//  Created by tam on 2017/9/11.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class AssetsDetailsModel: Mappable {
    
    var code: NSNumber?
    var msg: String?
    var data: [AssetsListDetailsModel]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
    
}
