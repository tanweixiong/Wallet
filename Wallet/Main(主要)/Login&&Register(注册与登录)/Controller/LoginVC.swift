//
//  LoginVC.swift
//  Wallet
//
//  Created by tam on 2017/8/28.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import FLAnimatedImage
import SVProgressHUD

enum LoginType {
    case chinaeseVersion
    case englishVersion
}
class LoginVC: WLMainViewController,CreateWalletDelegate,CreateMallWalletDelegate,CreateMyWalletDelegate {

    struct LoginUX {
        static let textFieldFont: CGFloat = YMAKE(14)
        static let loginButtonFont: CGFloat = YMAKE(16)
        static let textFieldWidth: CGFloat = XMAKE(300)
        static let textFieldHeight: CGFloat = YMAKE(44)
        static let fillet: CGFloat = 20
    }
    
    var logType = LoginType.chinaeseVersion
    let backgroundImageView = UIImageView()
    let logoImageView = UIImageView()
    let accountTextField = TPTextField()
    let passwordTextField = TPTextField()
    let loginButton = UIButton()
    let forgetpasswordButton = UIButton()
    let foundWallet  = UIButton()
    let languageButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarBgAlpha = "0.0"
        self.setCloseRoundKeyboard()
        self.createUI()
        foundWallet.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        forgetpasswordButton.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func onClick(_ sender:UIButton) {
        if sender.tag == 3 {
            self.login()
        }else{
            self.navigationController?.navigationBar.isHidden = false
            if sender.tag == 1 {
                let vc = CreateMyWalletVC()
                vc.delegate = self
                self.present(vc, animated: true, completion: {})
            }else{
                let vc = ForgetPwdViewController()
                vc.viewType = .getBackLoginPwd
                vc.topView.midLabel.text = LanguageHelper.getString(key: "retrieve_Login_Password")
                self.present(vc, animated: true, completion: {

                })
            }
        }
    }
    
    func login() {
        if checkInput() {

            SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "logging_in"), maskType: .black)
            
            let parameters:[String : Any]? = ["phone" : accountTextField.text!,"password" : passwordTextField.text!]
            
            Tools.loginToRefeshToken(parameters: parameters, haveParams: true, refreshSuccess: { (code, msg) in
                if code! == 100 {
                    //保存明文密码作为自动登录
//                    let userInfo = UserDefaults.standard.getUserInfo()
//                    userInfo.normalPassword = self.passwordTextField.text!
//                    userInfo.phone = self.accountTextField.text!
//                    UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                    
                    SVProgressHUD.dismiss()
                    LoginVC.setTabBarController()
                } else {
                    SVProgressHUD.showInfo(withStatus: msg!)
                }
                
            }, refreshFailture: { (error) in
                
            })
        }
    }
    
    func checkInput() -> Bool{
        
        if !Tools.validateMobile(mobile: accountTextField.text!) && !Tools.validateEmail(email: accountTextField.text!) {
            WLProgressHUD.showInfo(LanguageHelper.getString(key: "login_Mall_Phone"))
            return false
        }
        
        if !Tools.validatePassword(password: passwordTextField.text!) {
            WLProgressHUD.showInfo(LanguageHelper.getString(key: "enter_password_rule"))
            return false
        }
        return true
    }
    
    func getImageFromView(view:UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, view.layer.contentsScale);
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image;
    }
    
    func chooceLogin(){
        let vc = VariousLanguagesVC()
        vc.variousLanguagesNextStyle = .loginType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func createWalletFinish(_ account: String, _ password: String) {
         accountTextField.text = account
         passwordTextField.text = password
    }
    
    func createMallWalletFinish(_ account: String, _ password: String) {
        accountTextField.text = account
        passwordTextField.text = password
    }
    
    func createMyWalletFinish(_ account: String, _ password: String) {
        accountTextField.text = account
        passwordTextField.text = password
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LoginVC {
    
    func createUI() {
        let language = UserDefaults.standard.object(forKey: R_Languages) as! String
        if language == "en" {
            logType = .englishVersion
        }else{
            logType = .chinaeseVersion
        }
        self.view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(logoImageView)

        self.view.addSubview(accountTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(forgetpasswordButton)
        self.view.addSubview(foundWallet)
        self.view.addSubview(languageButton)
        
        self.backgroundImageView.frame = CGRect(x: 0, y: -64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 64)
        self.backgroundImageView.image = UIImage(named: "ic_loginbackground")
        
        logoImageView.image = UIImage(named: "logon_imageView")
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.backgroundImageView.snp.centerX)
            make.top.equalTo(self.backgroundImageView.snp.top).offset(YMAKE(140) + 64)
            make.width.equalTo(XMAKE(100))
            make.height.equalTo(XMAKE(100))
        }
        
        accountTextField.textColor = UIColor.white
        accountTextField.backgroundColor = UIColor(white: 1, alpha: 0.3);
        accountTextField.font = UIFont.systemFont(ofSize: LoginUX.textFieldFont)
        accountTextField.layer.cornerRadius = LoginUX.fillet;
        accountTextField.layer.borderWidth = 0.5
        accountTextField.keyboardType = .asciiCapable
        accountTextField.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor;
        accountTextField.placeholder = LanguageHelper.getString(key:"enter_phone")
        accountTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        accountTextField.clearButtonMode = .always
        let accountLeftView = UIImageView(image: UIImage(named: "ic_login_phone"));
        accountLeftView.frame = CGRect(x: 0, y: 0, width: XMAKE(40), height: YMAKE(28))
        accountLeftView.contentMode = .scaleAspectFit
        accountTextField.leftView = accountLeftView
        accountTextField.leftViewMode = .always
        accountTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(YMAKE(264) + 64)
            make.centerX.equalTo(self.backgroundImageView.snp.centerX)
            make.width.equalTo(LoginUX.textFieldWidth)
            make.height.equalTo(LoginUX.textFieldHeight)
        }
        
        passwordTextField.textColor = UIColor.white
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0.3)
        passwordTextField.font = UIFont.systemFont(ofSize: LoginUX.textFieldFont)
        passwordTextField.layer.cornerRadius = LoginUX.fillet;
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor;
        passwordTextField.placeholder = LanguageHelper.getString(key: "login_password")
        passwordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        passwordTextField.clearButtonMode = .always
        let passwordLeftView = UIImageView(image: UIImage(named: "ic_login_password"));
        passwordLeftView.frame = CGRect(x: 0, y: 0, width: XMAKE(40), height: YMAKE(28))
        passwordLeftView.contentMode = .scaleAspectFit
        passwordTextField.leftView = passwordLeftView
        passwordTextField.leftViewMode = .always
        passwordTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(accountTextField.snp.bottom).offset(YMAKE(20))
            make.centerX.equalTo(backgroundImageView.snp.centerX)
            make.width.equalTo(LoginUX.textFieldWidth)
            make.height.equalTo(LoginUX.textFieldHeight)
        }
        
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: LoginUX.loginButtonFont)
        loginButton.setTitleColor(R_UIThemeColor, for: .normal)
        loginButton.backgroundColor = UIColor.white
        loginButton.setTitle(LanguageHelper.getString(key: "login_wallet"), for: .normal)
        loginButton.layer.cornerRadius = LoginUX.fillet
        loginButton.tag = 3
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(YMAKE(20))
            make.centerX.equalTo(self.view.snp.centerX).offset(0)
            make.width.equalTo(LoginUX.textFieldWidth)
            make.height.equalTo(LoginUX.textFieldHeight)
        }
        
        let forgetSize:CGSize = (forgetpasswordButton.titleLabel?.getStringSize(text: LanguageHelper.getString(key: "forget_password"), size: CGSize(width: SCREEN_WIDTH, height: LoginUX.textFieldFont)))!
        forgetpasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: LoginUX.textFieldFont)
        forgetpasswordButton.setTitleColor(UIColor.white, for: .normal)
        forgetpasswordButton.setTitle(LanguageHelper.getString(key: "forget_password"), for: .normal)
        forgetpasswordButton.tag = 2
        forgetpasswordButton.titleLabel?.textAlignment = .right
        forgetpasswordButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(YMAKE(5))
            make.right.equalTo(self.loginButton.snp.right).offset(XMAKE(5))
            make.width.equalTo(forgetSize.width)
            make.height.equalTo(YMAKE(30))
        }
        
        let foundSize:CGSize = (foundWallet.titleLabel?.getStringSize(text: LanguageHelper.getString(key: "create_wallet"), size: CGSize(width: SCREEN_WIDTH, height: LoginUX.textFieldFont)))!
        foundWallet.titleLabel?.font = UIFont.systemFont(ofSize: LoginUX.textFieldFont)
        foundWallet.setTitleColor(UIColor.white, for: .normal)
        foundWallet.setTitle(LanguageHelper.getString(key: "create_wallet"), for: .normal)
        foundWallet.tag = 1
        foundWallet.titleLabel?.textAlignment = .left
        foundWallet.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(YMAKE(5))
            make.left.equalTo(self.loginButton.snp.left).offset(-XMAKE(5))
            make.width.equalTo(foundSize.width)
            make.height.equalTo(YMAKE(30))
        }
        
        foundWallet.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(YMAKE(5))
            make.left.equalTo(self.loginButton.snp.left).offset(-XMAKE(5))
            make.width.equalTo(foundSize.width)
            make.height.equalTo(YMAKE(30))
        }
        
        languageButton.setTitle(logType == .englishVersion ? "English" : "中文", for: .normal)
        languageButton.setTitleColor(UIColor.white, for: .normal)
        languageButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        languageButton.addTarget(self, action: #selector(LoginVC.chooceLogin), for: .touchUpInside)
        languageButton.titleLabel?.textAlignment = .right
        languageButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(YMAKE(30))
            make.right.equalTo(self.view.snp.right).offset(0)
            make.width.equalTo(XMAKE(100))
            make.height.equalTo(YMAKE(30))
        }
    }
    
    class func setTabBarController() {
        let tab = WLTabBarController()
        UIApplication.shared.keyWindow?.rootViewController = tab
    }
    
    class func setTokenInvalidation() {
        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "please_login_again"))
        UserDefaults.standard.set(false, forKey: R_Theme_isLogin)
        let navi = WLNavigationController(rootViewController: LoginVC())
        UIApplication.shared.keyWindow?.rootViewController = navi
    }
    
    class func switchRootVCToLoginVC() {
        UserDefaults.standard.set(false, forKey: R_Theme_isLogin)
        let navi = WLNavigationController(rootViewController: LoginVC())
        UIApplication.shared.keyWindow?.rootViewController = navi
    }
}


extension UIViewController {
    
    func setCloseRoundKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func closeKeyboard() {
        view.endEditing(true)
    }
}

