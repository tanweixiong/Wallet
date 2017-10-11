//
//  ManageWalletsModel.swift
//  Wallet
//
//  Created by tam on 2017/9/19.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class ManageWalletsData: Mappable{
    
    var user_id: String?
    var contacts_id: String?
    var remarks: String?
    var contacts_name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_id                <- map["user_id"]
        contacts_id            <- map["contacts_id"]
        remarks                <- map["remarks"]
        contacts_name          <- map["contacts_name"]

    }
}

class ManageWalletsModel: Mappable {
    
    var code: NSNumber?
    var msg: String?
    var data: [ManageWalletsData]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
}
