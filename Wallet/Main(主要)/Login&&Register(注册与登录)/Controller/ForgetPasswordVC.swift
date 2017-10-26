//
//  ForgetPasswordVC.swift
//  Wallet
//
//  Created by tam on 2017/8/29.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD

class ForgetPasswordVC: WLMainViewController {
    
    struct ForgetPasswordUX {
        static let textFieldFont: CGFloat = YMAKE(14)
        static let loginButtonFont: CGFloat = YMAKE(15)
        static let textFieldWidth: CGFloat = XMAKE(350)
        static let textFieldHeight: CGFloat = YMAKE(50)
        static let fillet: CGFloat = 10
        static let space: CGFloat = 14
    }

    var time:Int = 60
    let passwordTextField = UITextField()
    let accountTextField = UITextField()
    let codeTextField = UITextField()
    var getCodeButton:UIButton = UIButton(type:.custom)
    var finishButton:UIButton = UIButton(type:.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LanguageHelper.getString(key: "forget_password")
        
        self.navBarBgAlpha = "0"
        
        self.addDefaultBackBarButtonLeft()
        self.createUI()
        self.getCodeButton.addTarget(self, action: #selector(ForgetPasswordVC.getcode), for: .touchUpInside)
        self.finishButton.addTarget(self, action: #selector(ForgetPasswordVC.forgetPasswordOnClick),for: .touchUpInside)
    }
    
    func getcode() {
        if Tools.validateMobile(mobile: accountTextField.text!)  {
            let parameter = ["phone":accountTextField.text!]
            let url = ConstAPI.kAPIGetAuthorizeCode
            NetWorkTool.requestData(requestType: .post, URLString:url , parameters: parameter, showIndicator: false, success: { (success) in
                self.getCodeButton.isEnabled = false;
                self.setTimeCountDown()
            }, failture: { (error) in
                WLError(LanguageHelper.getString(key: "failed_verification_code"))
            })
        }else{
            WLError(LanguageHelper.getString(key: "please_enter_phone"))
        }
    }
    
    func forgetPasswordOnClick() {
        if checkInput() {
           let paramters = ["phone" : accountTextField.text! ,"newPassword1" : passwordTextField.text!, "code" : codeTextField.text!, "newPassword2" : passwordTextField.text!]
           NetWorkTool.requestData(requestType: .post, URLString: ConstAPI.kAPIRetrieveLoginPwd, parameters: paramters, showIndicator: true, success: { (json) in
            
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            
            if let code = responseData?.code {
                if code == 100 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "password_changes_succeeded"))
                    let time: TimeInterval = 1.0
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    
                    SVProgressHUD.showInfo(withStatus: responseData?.msg)
                }
            }
           }, failture: { (error) in
            
           })
        }
    }
    
    func setTimeCountDown() {
        // 在global线程里创建一个时间源
        let timer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        // 设定时间源的触发事件
        timer.setEventHandler(handler: {
            // 每秒计时一次
            self.time = self.time - 1
            DispatchQueue.main.async {
                self.getCodeButton.setTitle("\(self.time)秒", for: .normal)
            }
            // 时间到了取消时间源
            if self.time <= 0 {
                timer.cancel()
                // 返回主线程处理一些事件，更新UI等等
                DispatchQueue.main.async {
                    self.getCodeButton.setTitle(LanguageHelper.getString(key: "get_code"), for: .normal)
                    self.getCodeButton.backgroundColor = R_UIThemeColor
                    self.getCodeButton.isEnabled = true
                    self.time = 60
                }
            }
        })
        // 启动时间源
        timer.resume()
    }
    
    func checkInput() -> Bool{
        if !Tools.validateMobile(mobile: accountTextField.text!) {
            WLInfo(LanguageHelper.getString(key: "right_phone"))
            return false
        }
        
        if !Tools.validatePassword(password: passwordTextField.text!) {
            WLInfo(LanguageHelper.getString(key: "enter_password_rule"))
            return false
        }
        
        if codeTextField.text?.characters.count == 0 {
            WLInfo(LanguageHelper.getString(key: "register_code"))
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ForgetPasswordVC {
    
    func createUI() {
        
        self.view.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xF3F7F8)
        
        view.addSubview(passwordTextField)
        view.addSubview(accountTextField)
        view.addSubview(getCodeButton)
        view.addSubview(codeTextField)
        view.addSubview(finishButton)
        
        passwordTextField.textColor = R_UIFontLightColor
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.font = UIFont.systemFont(ofSize: ForgetPasswordUX.textFieldFont)
        passwordTextField.layer.cornerRadius = ForgetPasswordUX.fillet;
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor;
        passwordTextField.placeholder = LanguageHelper.getString(key: "password_enter")
        passwordTextField.setValue(R_UIFontLightColor, forKeyPath: "_placeholderLabel.textColor")
        passwordTextField.clearButtonMode = .always
        let passwordLeftView = UIImageView(image: UIImage(named: "ic_login_paswordg"));
        passwordLeftView.frame = CGRect(x: 0, y: 0, width: XMAKE(40), height: YMAKE(28))
        passwordLeftView.contentMode = .scaleAspectFit
        passwordTextField.leftView = passwordLeftView
        passwordTextField.leftViewMode = .always
        passwordTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.view).offset(YMAKE(ForgetPasswordUX.space))
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(ForgetPasswordUX.textFieldWidth)
            make.height.equalTo(ForgetPasswordUX.textFieldHeight)
        }
        
        accountTextField.textColor = R_UIFontLightColor
        accountTextField.backgroundColor = UIColor.white
        accountTextField.font = UIFont.systemFont(ofSize: ForgetPasswordUX.textFieldFont)
        accountTextField.layer.cornerRadius = ForgetPasswordUX.fillet;
        accountTextField.layer.borderWidth = 0.5
        accountTextField.keyboardType = .phonePad
        accountTextField.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor;
        accountTextField.placeholder = LanguageHelper.getString(key: "phone_enter")
        accountTextField.setValue(R_UIFontLightColor, forKeyPath: "_placeholderLabel.textColor")
        accountTextField.clearButtonMode = .always
        let accountLeftView = UIImageView(image: UIImage(named: "ic_login_phoneg"));
        accountLeftView.frame = CGRect(x: 0, y: 0, width: XMAKE(40), height: YMAKE(28))
        accountLeftView.contentMode = .scaleAspectFit
        accountTextField.leftView = accountLeftView
        accountTextField.leftViewMode = .always
        accountTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(passwordTextField.snp.bottom).offset(YMAKE(ForgetPasswordUX.space))
            make.left.equalTo(passwordTextField.snp.left)
            make.width.equalTo(XMAKE(240))
            make.height.equalTo(ForgetPasswordUX.textFieldHeight)
        }
        
        getCodeButton.setTitle(LanguageHelper.getString(key: "get_code"), for: .normal)
        getCodeButton.titleLabel!.font = UIFont.systemFont(ofSize: ForgetPasswordUX.textFieldFont)
        getCodeButton.layer.cornerRadius = ForgetPasswordUX.fillet
        getCodeButton.layer.borderWidth = 0.5
        getCodeButton.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
        //        getCodeButton.isEnabled = false
        getCodeButton.backgroundColor = R_UIThemeColor
        getCodeButton.setTitleColor(UIColor.white, for: .normal)
        getCodeButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(accountTextField.snp.top)
            make.right.equalTo(passwordTextField.snp.right)
            make.width.equalTo(XMAKE(100))
            make.height.equalTo(ForgetPasswordUX.textFieldHeight)
        }
        
        codeTextField.textColor = R_UIFontLightColor
        codeTextField.backgroundColor = UIColor.white
        codeTextField.font = UIFont.systemFont(ofSize: ForgetPasswordUX.textFieldFont)
        codeTextField.layer.cornerRadius = ForgetPasswordUX.fillet;
        codeTextField.layer.borderWidth = 0.5
        codeTextField.keyboardType = .asciiCapable
        codeTextField.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor;
        codeTextField.placeholder = LanguageHelper.getString(key: "code_enter")
        codeTextField.setValue(R_UIFontLightColor, forKeyPath: "_placeholderLabel.textColor")
        codeTextField.clearButtonMode = .always
        let codeLeftView = UIImageView(image: UIImage(named: "ic_login_verification"));
        codeLeftView.frame = CGRect(x: 0, y: 0, width: XMAKE(40), height: YMAKE(28))
        codeLeftView.contentMode = .scaleAspectFit
        codeTextField.leftView = codeLeftView
        codeTextField.leftViewMode = .always
        codeTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(accountTextField.snp.bottom).offset(YMAKE(ForgetPasswordUX.space))
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(ForgetPasswordUX.textFieldWidth)
            make.height.equalTo(ForgetPasswordUX.textFieldHeight)
        }
        
        finishButton.setTitle(LanguageHelper.getString(key: "confirm"), for: .normal)
        finishButton.titleLabel!.font = UIFont.systemFont(ofSize: ForgetPasswordUX.textFieldFont)
        finishButton.layer.cornerRadius = 22;
        finishButton.layer.borderWidth = 0.5
        finishButton.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
//        finishButton.isEnabled = false
        finishButton.setTitleColor(UIColor.white, for: .normal)
        finishButton.backgroundColor = R_UIThemeColor
        finishButton.snp.makeConstraints { (make) in
            make.top.equalTo(codeTextField.snp.bottom).offset(YMAKE(ForgetPasswordUX.space) + YMAKE(25))
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(XMAKE(300))
            make.height.equalTo(ForgetPasswordUX.textFieldHeight - XMAKE(5))
        }
        
    }
}
