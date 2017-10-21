//
//  NetWorkTool.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/21.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration
import SVProgressHUD
import SwiftyJSON

enum NetType: CustomStringConvertible {
    case WLWAN
    case WiFi
    
    var description : String {
        switch self {
        case .WLWAN: return "无线广域网"
        case .WiFi: return "WiFi"
        }
    }
}

enum NewStatus:CustomStringConvertible  {
    case OffLine
    case OnLine
    case Unknow
    
    var description: String {
        switch self {
        case .OffLine: return "离线"
        case .OnLine: return "在线"
        case .Unknow: return "未知"
        }
    }
}



class NetWorkTool: NSObject {
    
    class func request(requestType: HTTPMethod, URLString: String, parameters: [String : Any]?, showIndicator: Bool, success: @escaping (_ response : Any) -> () , failture: @escaping(_ error: Error) -> ()) {
        
        let sessionManager = Alamofire.SessionManager.default
        
        sessionManager.session.configuration.timeoutIntervalForRequest = 10
        
        let urlString = self.setUrl(URLString, self.setParameters(parameters!))
        
//        NetWorkTool.POST(urlw: urlString, param: self.setParameters(parameters!))
        
        sessionManager.request(urlString, method: requestType).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                print(value)
                success(value)
                
            case .failure(let error):
                
                failture(error)
                if showIndicator {
                    
                    SVProgressHUD.showError(withStatus: "网络出错")
                }
            }
        }
    }
    
    class func POST(urlw:String,param:String)
    {
 
        let path = urlw
        //拼接参数(GET请求参数需要以"?"连接拼接到请求地址的后面，多个参数用"&"隔开，参数形式：参数名=参数值)
        //size:请求数据的长度
        let path2 = path + param
        //转换成url(统一资源定位符)
        let url = NSURL(string: path2)!


        let urlRequest:URLRequest = URLRequest(url: url as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        // 3、响应对象
        var response:URLResponse?
        
        // 4、发出请求
        do {
            
            let received =  try NSURLConnection.sendSynchronousRequest(urlRequest, returning: &response)
            let dic = try JSONSerialization.jsonObject(with: received, options: JSONSerialization.ReadingOptions.allowFragments)
            print("----")
            print(dic)
            print("----")
    
        } catch let error{
            print(error.localizedDescription);
        }
    }
    

    class func requestData(requestType: HTTPMethod, URLString: String, parameters: [String : Any]?, showIndicator: Bool, success: @escaping (_ response : [String:AnyObject]) -> () , failture: @escaping(_ error: Error) -> ()) {
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.configuration.timeoutIntervalForRequest = 10
        if parameters != nil {
            sessionManager.request(URLString, method: requestType, parameters: parameters!).validate().responseJSON { (response) in
                
                print("all response info \(response)")
                
                switch response.result {
                case .success(let value):
                    success(value as! [String:AnyObject])
                    
                case .failure(let error):
                    
                    failture(error)
                    if showIndicator {
                        SVProgressHUD.showError(withStatus: "网络出错")
                    }
                }
            }
        } else {
            
            print(requestType)
            
            sessionManager.request(URLString, method: requestType).validate().responseJSON { (response) in
                
                print("all response info \(response)")
                
                switch response.result {
                case .success(let value):
                    success(value as! [String:AnyObject])
                    
                case .failure(let error):
                    
                    failture(error)
                    if showIndicator {
                        
                        SVProgressHUD.showError(withStatus: "网络出错")
                    }
                }
            }
        }
    }
    
    //关于文件上传的方法(支持多或者单上传)
    class func uploadPictures(url: String, parameter :[String:String], image: UIImage, imageKey: String,success : @escaping (_ response : [String : AnyObject])->(), fail : @escaping (_ error : Error)->()){
        let requestHead = ["content-type":"multipart/form-data"]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in parameter{
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName:key)
                }
                let imageName = Tools.getCurrentTime() + ".jpg"
                multipartFormData.append(UIImageJPEGRepresentation(image, 1.0)!, withName: imageKey, fileName: imageName, mimeType: "image/jpeg")
        },
            to: url,
            headers: requestHead,
            encodingCompletion: { result in
                switch result {
                    
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
                        }
                    }
                    
                case .failure(let error):
                    fail(error)
                }
        }
        )
    }
}

extension NetWorkTool {
    
    //转化成字符串参数
   class func setParameters (_ parameters: [String : Any]) -> String {
        let token = UserDefaults.standard.getUserInfo().token
    
        let timestamp = Tools.getCurrentTimeMillis()
        
        var keys = Array(parameters.keys)
        keys.append("token")
        keys.append("timestamp")
        
        var values = Array(parameters.values)
        values.append(token)
        values.append(timestamp)
        
        var string:String = ""
        for item in 0...keys.count - 1 {
            let key:String = keys[item]
            let value:String = values[item] as! String
            string = keys.count - 1 == item ? string + key + "=" + value : string + key + "=" + value + "&"
        }
        let url:String = string
        return url
    }
    
   class func setUrl(_ urlString:String,_ sign:String) -> String {
        let unsafeP = sign.addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn:"`#%^{}\"[]|\\<> ").inverted)!
        let url = urlString + "?" + unsafeP + "&sign=\(sign.md5())"
        return url
    }
    
}

