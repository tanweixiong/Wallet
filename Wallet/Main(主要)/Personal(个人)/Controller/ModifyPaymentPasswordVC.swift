//
//  ModifyPaymentPasswordVC.swift
//  Wallet
//
//  Created by tam on 2017/10/27.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class ModifyPaymentPasswordVC: UIViewController,UITextFieldDelegate {
    // MARK: - properties
    struct ViewStyle {
        static let topViewHeightRatio = 0.25
        static let btnRadius: CGFloat = 15
        static let loginBtnFontSize: CGFloat = 17
        static let topSpace: CGFloat = 40
        static let leftSpace: CGFloat = 30
        static let interSpace: CGFloat = 15
        static let textViewHeight: CGFloat = 35

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCloseRoundKeyboard()
        self.createUI()
    }

    func createUI(){
         self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.topView)
        self.view.addSubview(self.text)
        self.view.addSubview(self.originPwdTextView)
        self.view.addSubview(self.confirmBtn)
        
        self.topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(0)
            make.height.equalTo(self.view.snp.height).multipliedBy(ViewStyle.topViewHeightRatio)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
        
        self.text.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.topView.snp.bottom).offset(-33)
            make.height.equalTo(17)
            make.width.equalTo(SCREEN_WIDTH)
        }
   
        self.originPwdTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(ViewStyle.leftSpace)
            make.right.equalTo(self.view.snp.right).offset(-ViewStyle.leftSpace)
            make.top.equalTo(self.topView.snp.bottom).offset(ViewStyle.topSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.confirmBtn.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(45)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.top.equalTo(self.originPwdTextView.snp.bottom).offset(60)
        })
    }

    lazy var topView: LoginTopView =  {
        let view = LoginTopView()
        view.setBtnInitialStatus(viewType: .fixType)
        view.isUserInteractionEnabled = true
        view.backBtn.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        return view
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton.setBtnBoarderCorner(radius: ViewStyle.btnRadius)
        btn.backgroundColor = R_UIThemeColor
        btn.setTitle("确认", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: ViewStyle.loginBtnFontSize)
        btn.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var text: UILabel = {
        let label = UILabel()
        label.text =  LanguageHelper.getString(key: "set_pay_password")
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    lazy var originPwdTextView: LoginTextFieldView = {
        let view = LoginTextFieldView()
        view.addTextFieldAndRightBtn(viewType: LoginTextfieldViewType.DefaultType)
        view.leftImageView.image = UIImage.init(named: "mima")
        view.textField.setKeyboardStyle(textType: .TextFieldNumberLetter)
        view.textField.placeholder = LanguageHelper.getString(key: "set_pay_password")
        view.textField.delegate = self
        view.textField.keyboardType = .numberPad
        return view
    }()
    
    func confirmClick(){
        let text:String = self.originPwdTextView.textField.text!
        if text.characters.count < 5 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "enter_right_pay_pwd"))
        }else{
            self.setPayPassword(password: self.originPwdTextView.textField.text!)
        }
    }
    
    func setPayPassword(password:String) {
        let userId = UserDefaults.standard.getUserInfo().userId
        let password = password
        let parameters = ["userId":userId,"password":password]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"), maskType: .black)
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIAddPaymentPwd, parameters: parameters, showIndicator: true, success: { (json) in
            let data = json as! [String : Any]
            let code:Int = data["code"] as! Int
            let msg:String = data["msg"] as! String
            if code == 100 {
                SVProgressHUD.showSuccess(withStatus: msg)
                self.backToLogin()
            }else{
                SVProgressHUD.showError(withStatus:LanguageHelper.getString(key: "setup_failed"))
            }
        }) { (error) in
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        let textLength = text.characters.count + string.characters.count - range.length
        return textLength<=6
    }

    // MARK: - EventResponse
    func backToLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
