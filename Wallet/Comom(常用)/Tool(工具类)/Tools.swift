//
//  Tools.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/8.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import MJExtension

class Tools: NSObject {

    //判断是否为邮箱
    class func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._% -] @[A-Za-z0-9.-] \\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    //判断是否为电话号码
    class func validateMobile(mobile: String) -> Bool {
        //手机号以13,15,17,18开头，八个 \d 数字字符
        let phoneRegex = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: mobile)
    }
    
    //判断是否为密码
    class func validatePassword(password: String) -> Bool {
        let passwordRegex = "^[a-zA-Z0-9]{6,20}+$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    //判断是否为6位数字
    class func validateAuthorCode(code: String) -> Bool {
        let passwordRegex = "^\\d{6}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: code)
    }
    
    //图片data转化字符串
    class func 获取图片转化字符串返回字符串(图片: UIImage)-> String {
        var 数据: NSData;
        if (UIImagePNGRepresentation(图片) == nil)
        {
            数据 = UIImageJPEGRepresentation(图片, 1.0)! as NSData;
        }
        else
        {
            数据 = UIImagePNGRepresentation(图片)! as NSData;
        }
        let 图片内容: String =  数据.base64EncodedString(options: .lineLength64Characters)
        return 图片内容;
    }
    
    //获取当前时间
    class func getCurrentTime()-> String {
        let data = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "yyyMMddHHmmss"
        let currentTime = timeFormat.string(from: data as Date) as String
        return currentTime;
    }
    
    //获取价格的格式包含符号
    class func getConversionPriceFormatSymbol(_ price:String)-> String {
        let newPrice = String(format: "¥%.2f", NSString(string:price).floatValue/100)
        return newPrice
    }
    
    //获取服务器价格格式不包含符号
    class func getConversionPriceFormat(_ price:String)-> String {
        let newPrice = String(format: "%.2f", NSString(string:price).floatValue/100)
        return newPrice
    }
    
    //获取当前时间
    class func getCurrentTimeMillis()-> String {
        let now = NSDate()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "yyyMMddHHmmss"
        let timeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return String.init(timeStamp)
    }
    
    //创建二维码图片
    class func createQRForString(qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString{
            let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            //创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(stringData, forKey: "inputMessage")
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter?.outputImage
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            // 返回二维码image
            let codeImage = UIImage(ciImage: (colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5))))
            
            // 中间一般放logo
            if let logoImage = qrImageName {
                if let iconImage = UIImage(named: logoImage) {
                    let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                    
                    UIGraphicsBeginImageContext(rect.size)
                    codeImage.draw(in: rect)
                    let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
                    
                    let x = (rect.width - avatarSize.width) * 0.5
                    let y = (rect.height - avatarSize.height) * 0.5
                    iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                    
                    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                    
                    UIGraphicsEndImageContext()
                    return resultImage
                }
            }
            return codeImage
        }
        return nil
    }
    
    //调用登录功能
    class func loginToRefeshToken(parameters: [String : Any]?, haveParams: Bool, refreshSuccess: @escaping (_ code: Int?, _ msg: String?) -> () , refreshFailture: @escaping(_ error: Error) -> ()) {
        
        var params: [String : Any]?
        if haveParams {
            params = parameters
        } else {
            let phoneNo = UserDefaults.standard.value(forKey: "phone") as! String
            let pwd = UserDefaults.standard.value(forKey: "pwd") as! String
            params = ["phone" : phoneNo,"password" : pwd]
        }
        
        NetWorkTool.requestData(.post, URLString: ConstAPI.kAPILogin, parameters: params!, showIndicator: haveParams, success: { (json) in
            let userResponseData = Mapper<UserResponseData>().map(JSONObject: json)
            if let code = userResponseData?.code {
                if code == 100 {
                    if (json["data"] != nil) && String(describing: json["data"]) != "" {
                        let data = json["data"] as![String:AnyObject]
                        let user = data["user"] as![String:AnyObject]
                        UserDefaults.standard.set(true, forKey: R_Theme_isLogin)
                        let userInfo = UserInfo(dict: user as [String : AnyObject])
                        UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                        LoginConfiguration.shared.relatedConfiguration()
                    }
                }
            }
            refreshSuccess(userResponseData?.code, userResponseData?.msg)
            
        }) { (error) in
            refreshFailture(error)
        }
    }
    
    //保存归档
    class func savePlaceOnFile(_ file:String,_ data:Any)
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = (path as NSString).appendingPathComponent(file + ".plist")
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
    }
    
    //读取归档
    class func getPlaceOnFile(_ file:String) ->Any
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = (path as NSString).appendingPathComponent(file + ".plist")
        let data =  NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as Any
        return data
    }
    
    //根据ID进行排序
   class func sortByIDs(_ json:Any) -> Any{
        let coinIdArray = UserDefaults.standard.object(forKey:R_UserDefaults_Market_Details_Edit_Key) as! NSArray
        if coinIdArray.count == 0  {
            return json
        }
        let object:NSDictionary = json as! NSDictionary
        if (object.object(forKey: "data") != nil) {
            let dataArray = object.object(forKey: "data") as! NSArray
            if dataArray.count != 0 {
                let newArray = NSMutableArray()
                for item in 0...coinIdArray.count - 1 {
                    let coinID:String = coinIdArray[item] as! String
                    
                    for item in 0...dataArray.count - 1 {
                        let data = dataArray[item] as! NSDictionary
                        let dataID = data.object(forKey: "coin_no") as! String
                        if coinID.isEqual(dataID) {
                            newArray.add(data)
                        }
                    }
                }
                let code = object["code"]
                let msg = object["msg"]
                let newjson = ["code":code,"msg":msg,"data":newArray]
                return newjson
            }else{
                return json
            }
        }else{
            return json
        }
    }
    
}


