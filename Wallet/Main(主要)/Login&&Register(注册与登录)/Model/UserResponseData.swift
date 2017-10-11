//
//  UserResponseData.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/22.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import ObjectMapper

class UserResponseData: ResponseData {

    var data: UserInfoData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        data        <- map["data"]
    }
}
