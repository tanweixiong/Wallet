//
//  CreateWalletVC.swift
//  Wallet
//
//  Created by tam on 2017/8/28.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class CreateWalletVC: WLMainViewController,UITextFieldDelegate {
    
    struct CreateWalletUX {
        static let textFieldFont: CGFloat = YMAKE(14)
        static let loginButtonFont: CGFloat = YMAKE(15)
        static let textFieldWidth: CGFloat = XMAKE(350)
        static let textFieldHeight: CGFloat = YMAKE(50)
        static let fillet: CGFloat = 10
        static let space: CGFloat = 14
        static let backBtnRect: CGRect = CGRect.init(x: 10, y: 27, width: 25, height: 25)
    }
    
    struct ViewStyle {
        static let topViewHeightRatio = 0.25
    }
    
    var time:Int = 60
    let verifySuccessfulColor:UIColor = UIColor.R_UIColorFromRGB(color:0xf9ced7)
    let walletNameTextField = UITextField()
    let passwordTextField = UITextField()
    let accountTextField = UITextField()
    let codeTextField = UITextField()
    var getCodeButton:UIButton = UIButton(type:.custom)
    let createWallet = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.title = LanguageHelper.getString(key: "create_wallet")
        self.navBarBgAlpha = "1"
        
        self.addDefaultBackBarButtonLeft()
        self.setCloseRoundKeyboard()
        self.createUI()
        self.getCodeButton.addTarget(self, action: #selector(CreateWalletVC.getcode), for: .touchUpInside)
        self.createWallet.addTarget(self, action: #selector(CreateWalletVC.registerPhone), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateWalletVC.infoAction), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    func getcode() {
        if Tools.validateMobile(mobile: accountTextField.text!)  {
           let parameter = ["phone":accountTextField.text!]
           let url = ConstAPI.kAPIGetAuthorizeCode
           NetWorkTool.requestData(.post, URLString:url , parameters: parameter, showIndicator: false, success: { (success) in
              self.getCodeButton.isEnabled = false;
              self.setTimeCountDown()
           }, failture: { (error) in
                WLError("获取验证码失败")
           })
        }else{
            WLInfo("请输入正确的手机号码")
        }
    }
    
    func registerPhone() {
        if checkInput() {
        let paramters = ["phone":accountTextField.text!,"password":passwordTextField.text!,"code":codeTextField.text!,"username":walletNameTextField.text!]
            
         NetWorkTool.requestData(.post, URLString: ConstAPI.kAPIRegister, parameters: paramters, showIndicator: true, success: { (json) in
                let responseData = Mapper<ResponseData>().map(JSONObject: json)
                if let code = responseData?.code {
                    if code == 100 {
                        WLSuccess(responseData?.msg)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        WLInfo(responseData?.msg)
                    }
                }
            }, failture: { (error) in
                
            })
        }
    }
    
    func checkInput() -> Bool{
        
        if !Tools.validateMobile(mobile: accountTextField.text!) && !Tools.validatePassword(password: passwordTextField.text!) && walletNameTextField.text?.characters.count == 0 && codeTextField.text?.characters.count == 0{
            WLInfo(LanguageHelper.getString(key: "input_can_not_be_empty"))
            return false
        }
        
        if !Tools.validateMobile(mobile: accountTextField.text!) {
            WLInfo(LanguageHelper.getString(key: "enter_phone"))
            return false
        }
        
        if !Tools.validatePassword(password: passwordTextField.text!) {
            WLInfo(LanguageHelper.getString(key: "enter_password"))
            return false
        }
        
        if walletNameTextField.text?.characters.count == 0 {
            WLInfo(LanguageHelper.getString(key: "wallet_name_enter"))
            return false
        }
        
        if codeTextField.text?.characters.count == 0 {
            WLInfo(LanguageHelper.getString(key: "register_code"))
            return false
        }
        return true
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
                    self.getCodeButton.setTitle(LanguageHelper.getString(key: "register_getcode"), for: .normal)
                    self.getCodeButton.backgroundColor = R_UIThemeColor
                    self.getCodeButton.isEnabled = true
                    self.time = 60
                }
            }
        })
        // 启动时间源
        timer.resume()
    }
    
    func infoAction() {
        if codeTextField.text?.characters.count != 0 {
            self.time = 0
        }
    }
    
    lazy var topView: UIView =  {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        view.backgroundColor = R_UIThemeColor
        let backBtn = UIButton(type: .custom)
        backBtn.setBackgroundImage(UIImage.init(named: "cuowu"), for: .normal)
        backBtn.frame = CreateWalletUX.backBtnRect
        backBtn.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        view.addSubview(backBtn)
        
        let label = UILabel(frame: CGRect(x: 0, y: 32, width: SCREEN_WIDTH, height: 18))
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "创建钱包"
        view.addSubview(label)
        return view
    }()
    
    // MARK: - EventResponse
    func backToLogin() {
        self.dismiss(animated: true, completion: nil)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CreateWalletVC {
    
    func createUI() {
        self.view.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xF3F7F8)
        
        self.view.addSubview(topView)
        self.view.addSubview(walletNameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(accountTextField)
        self.view.addSubview(getCodeButton)
        self.view.addSubview(codeTextField)
        self.view.addSubview(createWallet)
        
        self.topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(0)
            make.height.equalTo(64)
        }
        
        walletNameTextField.textColor = R_UIFontLightColor
        walletNameTextField.backgroundColor = UIColor.white
        walletNameTextField.font = UIFont.systemFont(ofSize: CreateWalletUX.textFieldFont)
        walletNameTextField.layer.cornerRadius = CreateWalletUX.fillet;
        walletNameTextField.layer.borderWidth = 0.5
//        walletNameTextField.keyboardType = .asciiCapable
//        walletNameTextField.isSecureTextEntry = true
        walletNameTextField.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor;
        walletNameTextField.placeholder = LanguageHelper.getString(key: "wallet_name")
        walletNameTextField.setValue(R_UIFontLightColor, forKeyPath: "_placeholderLabel.textColor")
        walletNameTextField.clearButtonMode = .always
        let walletNameLeftView = UIImageView(image: UIImage(named: "ic_login_name"));
        walletNameLeftView.frame = CGRect(x: 0, y: 0, width: XMAKE(40), height: YMAKE(28))
        walletNameLeftView.contentMode = .scaleAspectFit
        walletNameTextField.leftView = walletNameLeftView
        walletNameTextField.leftViewMode = .always
        walletNameTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(topView.snp.bottom).offset(YMAKE(CreateWalletUX.space))
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(CreateWalletUX.textFieldWidth)
            make.height.equalTo(CreateWalletUX.textFieldHeight)
        }
        
        passwordTextField.textColor = R_UIFontLightColor
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.font = UIFont.systemFont(ofSize: CreateWalletUX.textFieldFont)
        passwordTextField.layer.cornerRadius = CreateWalletUX.fillet;
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor;
        passwordTextField.placeholder =  LanguageHelper.getString(key: "password_enter")
        passwordTextField.setValue(R_UIFontLightColor, forKeyPath: "_placeholderLabel.textColor")
        passwordTextField.clearButtonMode = .always
        let passwordLeftView = UIImageView(image: UIImage(named: "ic_login_paswordg"));
        passwordLeftView.frame = CGRect(x: 0, y: 0, width: XMAKE(40), height: YMAKE(28))
        passwordLeftView.contentMode = .scaleAspectFit
        passwordTextField.leftView = passwordLeftView
        passwordTextField.leftViewMode = .always
        passwordTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(walletNameTextField.snp.bottom).offset(YMAKE(CreateWalletUX.space))
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(CreateWalletUX.textFieldWidth)
            make.height.equalTo(CreateWalletUX.textFieldHeight)
        }
        
        accountTextField.textColor = R_UIFontLightColor
        accountTextField.backgroundColor = UIColor.white
        accountTextField.font = UIFont.systemFont(ofSize: CreateWalletUX.textFieldFont)
        accountTextField.layer.cornerRadius = CreateWalletUX.fillet;
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
            make.top.equalTo(passwordTextField.snp.bottom).offset(YMAKE(CreateWalletUX.space))
            make.left.equalTo(passwordTextField.snp.left)
            make.width.equalTo(XMAKE(240))
            make.height.equalTo(CreateWalletUX.textFieldHeight)
        }
        
        getCodeButton.setTitle(LanguageHelper.getString(key: "register_getcode"), for: .normal)
        getCodeButton.titleLabel!.font = UIFont.systemFont(ofSize: CreateWalletUX.textFieldFont)
        getCodeButton.layer.cornerRadius = CreateWalletUX.fillet
        getCodeButton.layer.borderWidth = 0.5
        getCodeButton.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
//        getCodeButton.isEnabled = false
        getCodeButton.backgroundColor = R_UIThemeColor
        getCodeButton.setTitleColor(UIColor.white, for: .normal)
        getCodeButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(accountTextField.snp.top)
            make.right.equalTo(passwordTextField.snp.right)
            make.width.equalTo(XMAKE(100))
            make.height.equalTo(CreateWalletUX.textFieldHeight)
        }
        
        codeTextField.textColor = R_UIFontLightColor
        codeTextField.backgroundColor = UIColor.white
        codeTextField.font = UIFont.systemFont(ofSize: CreateWalletUX.textFieldFont)
        codeTextField.layer.cornerRadius = CreateWalletUX.fillet;
        codeTextField.layer.borderWidth = 0.5
        codeTextField.keyboardType = .asciiCapable
        codeTextField.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor;
        codeTextField.placeholder =  LanguageHelper.getString(key: "code_enter")
        codeTextField.setValue(R_UIFontLightColor, forKeyPath: "_placeholderLabel.textColor")
        codeTextField.clearButtonMode = .always
        let codeLeftView = UIImageView(image: UIImage(named: "ic_login_verification"));
        codeLeftView.frame = CGRect(x: 0, y: 0, width: XMAKE(40), height: YMAKE(28))
        codeLeftView.contentMode = .scaleAspectFit
        codeTextField.leftView = codeLeftView
        codeTextField.leftViewMode = .always
        codeTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(accountTextField.snp.bottom).offset(YMAKE(CreateWalletUX.space))
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(CreateWalletUX.textFieldWidth)
            make.height.equalTo(CreateWalletUX.textFieldHeight)
        }
        
        createWallet.setTitle(LanguageHelper.getString(key: "create_wallet"), for: .normal)
        createWallet.titleLabel!.font = UIFont.systemFont(ofSize: CreateWalletUX.textFieldFont)
        createWallet.layer.cornerRadius = 22;
        createWallet.layer.borderWidth = 0.5
        createWallet.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor;
        createWallet.setTitleColor(UIColor.white, for: .normal)
        createWallet.backgroundColor = R_UIThemeColor
        createWallet.snp.makeConstraints { (make) in
            make.top.equalTo(codeTextField.snp.bottom).offset(YMAKE(CreateWalletUX.space) + YMAKE(25))
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(XMAKE(300))
            make.height.equalTo(CreateWalletUX.textFieldHeight - XMAKE(5))
        }
    }
}
