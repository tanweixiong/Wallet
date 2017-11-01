//
//  codeConfiguration.swift
//  Wallet
//
//  Created by tam on 2017/10/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
//type1首页 type2转账 type3名片
//  @[address,amount,type,businesscard];
class CodeConfiguration: NSObject {

    class func getCardCodeConfiguration(_ type:String,_ data:String) ->String{
        let userId = UserDefaults.standard.getUserInfo().userId
        let codeString = R_Theme_QRCode + ":" + userId + "?" + "type=" + type + "&" + "businesscard=" + data
        return codeString
    }
    
    class func codeProcessing(_ vc:UIViewController,_ data:NSArray,success : @escaping (_ response : String,_ type : String)->()){
        let address = data[0] as! String
        let amount = data[1] 
        let type:String = data[2] as! String
        let businesscard:String = data[3] as! String
        //首页
        if type == "1" {
            success(address,type)
        //转账
        }else if type == "2"{
            success(address,type)
        //名片 直接添加好友
        }else if type == "3" {
            self.addFriendBusinessCard(vc, businesscard)
            success(address,type)
        }
    }
    
    //添加好友
    class func addFriendBusinessCard(_ vc:UIViewController,_ data:String){
        vc.navigationController?.popToRootViewController(animated: false)
        
        let dict =  (WalletOCTools.getDictionaryFromJSONString(data))!
        
        let responseData = Mapper<MineBusinessCardData>().map(JSONObject: dict)
        let model:MineBusinessCardData = (responseData)!
        
        let responseCodeData = Mapper<MineBusinessCardCodeDataModel>().map(JSONObject: dict)
        let codeModel:MineBusinessCardCodeDataModel = (responseCodeData)!
        
        var ids = String(describing: codeModel.id)
        ids = ids.replacingOccurrences(of: "Optional(", with: "")
        ids = ids.replacingOccurrences(of: ")", with: "")
        
        model.id = ids
        
        let addBusiessCardVC = AddBusiessCardVC()
        addBusiessCardVC.mineBusinessCardData = model
        addBusiessCardVC.addBusinessCardType = .addBusiessFriendCard
        addBusiessCardVC.busiessCardType = .addBusiessFriendCard
        vc.navigationController?.pushViewController(addBusiessCardVC, animated: true)
    }
}
