//
//  AssetsListDetailsModel.swift
//  Wallet
//
//  Created by tam on 2017/9/12.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class AssetsListDetailsModel: Mappable {
    
    var coin_name: String?
    var coin_no: NSNumber?
    var state: NSNumber?
    var coinIcon: String?
    var icon:String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        
        coin_name        <- map["coin_name"]
        coin_no          <- map["coin_no"]
        state            <- map["state"]
        coinIcon         <- map["coinIcon"]
        icon             <- map["icon"]
    }
    
}
