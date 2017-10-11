//
//  SettingPaypsdVC.swift
//  DHSWallet
//
//  Created by tam on 2017/9/6.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class SettingPaypsdVC: WLMainViewController {
    
    let passcodeField =  UXPasscodeField()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addDefaultBackBarButtonLeft()
        
        self.title = LanguageHelper.getString(key: "set_pay_password")
        self.view.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xEBF0F3)
        
        let sizes:CGSize = titleLabel.getStringSize(text: titleLabel.text!, size: CGSize(width: SCREEN_WIDTH - 40, height: CGFloat(MAXFLOAT)))
        titleLabel.frame = CGRect(x: 20, y: 20, width: sizes.width, height: sizes.height)
        self.view.addSubview(titleLabel)

        passcodeField.frame = CGRect(x: 30, y:titleLabel.frame.maxY + 10 , width: SCREEN_WIDTH - 60, height: 45)
        passcodeField.isSecureTextEntry = true
        passcodeField.addTarget(self, action: #selector(SettingPaypsdVC.passcodeFieldDidChangeValue), for: .valueChanged)
        self.view.addSubview(passcodeField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func passcodeFieldDidChangeValue() {
        if passcodeField.passcode.characters.count == 6 {
            self.setPayPassword(password: passcodeField.passcode)
        }
    }
    
    func setPayPassword(password:String) {
        let userId = UserDefaults.standard.getUserInfo().userId
        let password = password
        let parameters = ["userId":userId,"password":password]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"), maskType: .black)
        NetWorkTool.request(.post, URLString: ConstAPI.kAPIAddPaymentPwd, parameters: parameters, showIndicator: true, success: { (json) in
            let data = json as! [String : Any]
            let code:Int = data["code"] as! Int
            let msg:String = data["msg"] as! String
            if code == 100 {
                SVProgressHUD.showSuccess(withStatus: msg)
                self.perform(#selector(SettingPaypsdVC.pop), with: nil, afterDelay: 1)
            }else{
                 SVProgressHUD.showError(withStatus:LanguageHelper.getString(key: "setup_failed"))
            }
        }) { (error) in
            
        }
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x436071)
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = LanguageHelper.getString(key: "set_payment")
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x999999)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        return label
    }()

}
