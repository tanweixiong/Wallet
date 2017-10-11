//
//  UserInfoData.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/22.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import ObjectMapper

class UserInfoData: Mappable {
    
    var user: UserInfo?
    var token: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user        <- map["user"]
        token       <- map["token"]
    }
}
