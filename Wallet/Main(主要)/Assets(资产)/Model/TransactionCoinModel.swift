//
//  TransactionCoinModel.swift
//  Wallet
//
//  Created by tam on 2017/9/29.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class TransactionList: Mappable{
    
    var coin_no: NSNumber?
    var flag: NSNumber?
    var serialNumber: String?
    var endDate: String?
    var remark:   String?
    var type: NSNumber?
    var userId: String?
    var operateflag: NSNumber?
    var receivablesNumber: NSNumber?
    var beginDate: String?
    var operate: String?
    var money: NSNumber?
    var receivablesName: String?
    var id: NSNumber?
    var state: NSNumber?
    var paymentName: String?
    var paymentNumber: NSNumber?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        coin_no                <- map["coin_no"]
        flag                   <- map["flag"]
        serialNumber           <- map["serialNumber"]
        endDate                <- map["endDate"]
        remark                 <- map["remark"]
        type                   <- map["type"]
        userId                 <- map["userId"]
        operateflag            <- map["operateflag"]
        receivablesNumber      <- map["receivablesNumber"]
        beginDate              <- map["beginDate"]
        operate                <- map["operate"]
        money                  <- map["money"]
        receivablesName        <- map["receivablesName"]
        id                     <- map["id"]
        state                  <- map["state"]
        paymentName            <- map["paymentName"]
        paymentNumber          <- map["paymentNumber"]
    }
}

class currentPage: Mappable {
    var data: [TransactionList]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data        <- map["currentPage"]
    }
}

class TransactionCoinModel: Mappable {
    
    var code: String?
    var msg: String?
    var data: currentPage?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        msg         <- map["msg"]
        data        <- map["data"]
    }
}




