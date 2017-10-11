//
//  AssetsListModel.swift
//  Wallet
//
//  Created by tam on 2017/9/9.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class AssetsListModel: Mappable{
    
    var allmoney: NSNumber?
    var asset_freeze: NSNumber?
    var coinIcon: String?
    var coin_name: String?
    var coin_no: NSNumber?
    var date: String?
    var id: NSNumber?
    var market_state: NSNumber?
    var remainderMoney: NSNumber?
    var state: NSNumber?
    var sumMoney: NSNumber?
    var userId: String?
    var username: String?
    var userphoto: String?
    var wallet_qr_code: String?
    
    required init?(map: Map) {
        
    }
    
    required init(){
        
    }
    
    func mapping(map: Map) {
        allmoney              <- map["allmoney"]
        asset_freeze          <- map["asset_freeze"]
        coinIcon              <- map["coinIcon"]
        coin_name             <- map["coin_name"]
        coin_no               <- map["coin_no"]
        date                  <- map["date"]
        id                    <- map["id"]
        market_state          <- map["market_state"]
        remainderMoney        <- map["remainderMoney"]
        state                 <- map["state"]
        sumMoney              <- map["sumMoney"]
        userId                <- map["userId"]
        username              <- map["username"]
        userphoto             <- map["userphoto"]
        wallet_qr_code        <- map["wallet_qr_code"]
    }
}
