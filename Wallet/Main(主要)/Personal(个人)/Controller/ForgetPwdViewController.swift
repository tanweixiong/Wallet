//
//  ForgetPwdViewController.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/14.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD
import Alamofire

enum ForgetPwdViewType: Int {
    case modifyLoginPwd = 0
    case modifyPayPwd
    case getBackPayPwd
    case getBackLoginPwd
}

class ForgetPwdViewController: UIViewController {
    
    // MARK: - properties
    struct ViewStyle {
        static let topViewHeightRatio = 0.25
    }
    
    var viewType: ForgetPwdViewType = .modifyPayPwd {
        didSet {
            self.setupSubviews()
        }
    }
    
    lazy var topView: LoginTopView =  {
        let view = LoginTopView()
        view.setBtnInitialStatus(viewType: .fixType)
        view.isUserInteractionEnabled = true
        view.backBtn.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        return view
    }()
    
    lazy var modifyView: ModifyPwdView = {
        let view = ModifyPwdView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.75))
        view.commitBtn.addTarget(self, action: #selector(ForgetPwdViewController.comfirmNewPwd), for: .touchUpInside)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var forgetView: ForgetPwdView = {
        let view = ForgetPwdView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.75))
        view.registerBtn.addTarget(self, action: #selector(ForgetPwdViewController.comfirmNewPwd), for: .touchUpInside)
        view.authorizeTextView.rightAutorBtn.addTarget(self, action: #selector(ForgetPwdViewController.authorizeBtnClick(btn:)), for: .touchUpInside)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
    }
    
    func setupSubviews() {
        self.view.addSubview(topView)
        
        self.topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(0)
            make.height.equalTo(self.view.snp.height).multipliedBy(ViewStyle.topViewHeightRatio)
        }
        
        switch self.viewType {
        case .modifyPayPwd, .modifyLoginPwd:
            
            self.view.addSubview(self.modifyView)
            self.modifyView.snp.makeConstraints({ (make) in
                make.left.bottom.right.equalTo(self.view)
                make.top.equalTo(self.topView.snp.bottom)
            })
            
            if self.viewType == .modifyPayPwd {
                self.modifyView.originPwdTextView.textField.textType = DHSTextFieldType.TextFieldPaymentNumber
                self.modifyView.newPwdTextView.textField.textType = DHSTextFieldType.TextFieldPaymentNumber
                self.modifyView.confirmPwdTextView.textField.textType = DHSTextFieldType.TextFieldPaymentNumber
            }
            
        case .getBackPayPwd, .getBackLoginPwd:
            self.view.addSubview(forgetView)
            self.forgetView.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(self.view)
                make.top.equalTo(self.topView.snp.bottom)
            }
            
            if self.viewType == .getBackPayPwd {
                self.modifyView.originPwdTextView.textField.textType = DHSTextFieldType.TextFieldIntegerNumber
                self.modifyView.newPwdTextView.textField.textType = DHSTextFieldType.TextFieldIntegerNumber
                self.modifyView.confirmPwdTextView.textField.textType = DHSTextFieldType.TextFieldIntegerNumber
            }
        }
        
        //设置支付密码
        if viewType == .modifyPayPwd {
            self.modifyView.originPwdTextView.textField.setKeyboardStyle(textType: .TextFieldPaymentNumber)
            self.modifyView.newPwdTextView.textField.setKeyboardStyle(textType: .TextFieldPaymentNumber)
            self.modifyView.confirmPwdTextView.textField.setKeyboardStyle(textType: .TextFieldPaymentNumber)
        }
    
        self.view.backgroundColor = UIColor.white
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(viewTouched))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    
    // MARK: - EventResponse
    func backToLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func comfirmNewPwd() {
        
        var phoneNo: String?
        var authorCode: String?
        var pwd: String?
        var confirmPwd: String?
        var oldPwd : String?
        
        switch self.viewType {
        case .getBackLoginPwd, .getBackPayPwd:
            phoneNo = self.forgetView.phoneTextView.textField.text
            authorCode = self.forgetView.authorizeTextView.textField.text
            pwd = self.forgetView.pwdTextView.textField.text
            confirmPwd = self.forgetView.confirmPwdTextView.textField.text
            
            if !Tools.validateMobile(mobile: phoneNo!) {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "right_phone"))
                return
            }
            
            if !Tools.validateAuthorCode(code: self.forgetView.authorizeTextView.textField.text!) {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "register_code"))
                return
            }
            
        case .modifyPayPwd:
            oldPwd = self.modifyView.originPwdTextView.textField.text!
            pwd = self.modifyView.newPwdTextView.textField.text!
            confirmPwd = self.modifyView.confirmPwdTextView.textField.text!
            
            
        case .modifyLoginPwd:
            oldPwd = self.modifyView.originPwdTextView.textField.text!
            pwd = self.modifyView.newPwdTextView.textField.text!
            confirmPwd = self.modifyView.confirmPwdTextView.textField.text!
            
            
            if !Tools.validatePassword(password: oldPwd!) {
                SVProgressHUD.showInfo(withStatus:LanguageHelper.getString(key: "enter_password_rule"))
                return
            }
            
            if !Tools.validatePassword(password: pwd!) || !Tools.validatePassword(password: confirmPwd!) {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "enter_password_rule"))
                return
            }

        }
        
        if pwd != confirmPwd {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "two_password_different"))
            return
        }
        
        let userId = UserDefaults.standard.getUserInfo().userId
        let token = UserDefaults.standard.getUserInfo().token
        let timestamp = Tools.getCurrentTimeMillis()
        
        switch self.viewType {
        case .getBackLoginPwd:
            let paramters = ["phone" : phoneNo!,"newPassword1" : pwd!, "code" : authorCode!, "newPassword2" : confirmPwd!]
            self.retrievePwd(paramters: paramters, url: ConstAPI.kAPIRetrieveLoginPwd)
        case .getBackPayPwd:
            let paramters = ["phone" : phoneNo!,"Password1" : pwd!, "code" : authorCode!, "Password2" : confirmPwd!]
            self.retrievePwd(paramters: paramters, url: ConstAPI.kAPIRetrievePaymentPwd)
        case .modifyLoginPwd, .modifyPayPwd:
            let sign = "newPassword1=\(pwd!)&newPassword2=\(confirmPwd!)&oldPassword=\(oldPwd!)&token=\(token)&timestamp=\(timestamp)&userId=\(userId)"
            let paramstring = sign + "&sign=\(sign.md5())"
            let urlstring = ConstAPI.kAPIModifyLoginPwd + "?" + paramstring
            
            if viewType == .modifyPayPwd {
                self.modifyPaymentPassword()
            }else{
               self.modifyPwd(url: urlstring)
            }
        }
    }
    
    func authorizeBtnClick(btn: AutorizeButton) {
        
        if !Tools.validateMobile(mobile: self.forgetView.phoneTextView.textField.text!) {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "right_phone"))
            return
        }
        
        btn.isCounting = true
        self.getAuthorizeCode()
        
    }
    
    func viewTouched() {
        
        self.view.endEditing(true)
    }
    
    // MARK: - NetWork
    func retrievePwd(paramters: [String : Any], url: String) {
        
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "modifying_password") , maskType: .black)
        
        NetWorkTool.requestData(requestType: .post, URLString: url, parameters: paramters, showIndicator: true, success: { (json) in
            
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            
            if let code = responseData?.code {
                if code == 100 {
                    
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "password_changes_succeeded"))
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    
                    SVProgressHUD.showInfo(withStatus: responseData?.msg)
                }
            }
        }) { (error) in
            
        }
    }
    
    func modifyPaymentPassword (){
        self.view.endEditing(true)
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "modifying_password"), maskType: .black)
        let url = ConstAPI.kAPIModifyPaymentPwd
        let userId = UserDefaults.standard.getUserInfo().userId
        let oldPassword = self.modifyView.originPwdTextView.textField.text!
        let newPassword1 = self.modifyView.newPwdTextView.textField.text!
        let newPassword2 = self.modifyView.confirmPwdTextView.textField.text!
        let parameters = ["newPassword1":newPassword1,"newPassword2":newPassword2,"oldPassword":oldPassword,"userId":userId]
        NetWorkTool.request(requestType: .post, URLString: url, parameters: parameters, showIndicator: true, success: { (json) in
            let data = json as! [String : Any]
            let code:Int = data["code"] as! Int
            let msg:String = data["msg"] as! String
            if code == 100 {
                SVProgressHUD.showSuccess(withStatus: msg)
                self.backToLogin()
            }else{
                SVProgressHUD.showInfo(withStatus: msg)
            }
        }) { (error) in
        }
    }
    
    func modifyPwd(url: String) {
        
        self.view.endEditing(true)
        
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "modifying_password"), maskType: .black)
        NetWorkTool.requestData(requestType: .post, URLString: url, parameters: nil, showIndicator: true, success: { (json) in
            
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            
            if let code = responseData?.code {
                if code == 100 {
                    
                    if self.viewType == .modifyLoginPwd {
                        //延时1秒执行
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "password_changes_succeeded"))
                        let time: TimeInterval = 1.0
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                            LoginVC.switchRootVCToLoginVC()
                        }
                    } else if self.viewType == .modifyPayPwd {
                        self.dismiss(animated: true, completion: nil)
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "payment_modified"))
                    }
                } else if code == 301 {
                    LoginVC.setTokenInvalidation()
                } else {
                    
                    SVProgressHUD.showInfo(withStatus: responseData?.msg)
                }
            }
        }) { (error) in
            
        }
    }
    
    func getAuthorizeCode() {
        
        let phoneNo = self.forgetView.phoneTextView.textField.text!
        
        let paramters = ["phone" : phoneNo]
        
        NetWorkTool.requestData(requestType: .get, URLString: ConstAPI.kAPIGetAuthorizeCode, parameters: paramters, showIndicator: true, success: { (json) in
            
            let result = Mapper<ResponseData>().map(JSONObject: json)
            
            if let code = result?.code {
                
                if code == 100 {
                    
                } else {
                    
                    self.forgetView.authorizeTextView.rightAutorBtn.changeToOriginState()
                }
            }
            
        }) { (error) in
            
            self.forgetView.authorizeTextView.rightAutorBtn.changeToOriginState()
            
        }
    }

}
