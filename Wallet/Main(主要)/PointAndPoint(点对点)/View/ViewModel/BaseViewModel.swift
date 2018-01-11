
import UIKit
import SVProgressHUD
import Alamofire
import ObjectMapper

enum BaseRequestType{
    case post
    case get
}

class BaseViewModel: NSObject {
    var  baseRequestType = BaseRequestType.post
    lazy var responseData: [ResponseData] = [ResponseData]()
    //一般请求的方法 不带模型数组
    class func loadSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        NetWorkTool.request(requestType: requestType, URLString:URLString, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            if let code = responseData?.code {
                guard  100 == code else {
                    SVProgressHUD.showInfo(withStatus: responseData?.msg)
                    return
                }
                if showIndicator {
                    SVProgressHUD.showSuccess(withStatus: responseData?.msg)
                }
                finishedCallback()
            }
        }) { (error) in
        }
    }
}
