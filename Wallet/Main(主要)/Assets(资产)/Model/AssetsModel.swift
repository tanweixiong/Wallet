//
//  AssetsModel.swift
//  Wallet
//
//  Created by tam on 2017/9/9.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class AssetsModel: Mappable {
    
    var code: NSNumber?
    var msg: String?
    var data: [AssetsListModel]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
    
}
