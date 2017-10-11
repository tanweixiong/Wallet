//
//  LoginView.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/10.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    fileprivate struct ViewStyle {
        static let topSpace: CGFloat = 50
        static let leftSpace: CGFloat = 30
        static let interSpace: CGFloat = 15
        static let textViewHeight: CGFloat = 35
        static let btnRadius: CGFloat = 15
        static let loginBtnFontSize: CGFloat = 17
        static let forgetBtnFontSize: CGFloat = 14
    }

    // MARK: - Properties
    
    lazy var phoneTextView: LoginTextFieldView = {
        let view = LoginTextFieldView()
        view.addTextFieldAndRightBtn(viewType: LoginTextfieldViewType.RightBtnType)
        view.rightBtn.setBackgroundImage(UIImage.init(named: "xia"), for: UIControlState.normal)
        view.leftImageView.image = UIImage.init(named: "shouji")
        view.isUserInteractionEnabled = true
        view.textField.setKeyboardStyle(textType: .TextFieldIntegerNumber)
        view.textField.placeholder = "请输入手机号码"
        return view
    }()
    
    lazy var pwdTextView: LoginTextFieldView = {
        let view = LoginTextFieldView()
        view.addTextFieldAndRightBtn(viewType: LoginTextfieldViewType.RightBtnType)
        view.rightBtn.setBackgroundImage(UIImage.init(named: "biyan"), for: UIControlState.normal)
        view.rightBtn.setBackgroundImage(UIImage.init(named: "zhengyan"), for: UIControlState.selected)
        view.leftImageView.image = UIImage.init(named: "mima")
        view.textField.setKeyboardStyle(textType: .TextFieldNumberLetter)
        view.textField.placeholder = "请输入登录密码"
        view.textField.isSecureTextEntry = true
        view.rightBtn.addTarget(self, action: #selector(switchSecurityMode(sender:)), for: .touchUpInside)
        return view
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton.setBtnBoarderCorner(radius: ViewStyle.btnRadius)
        btn.backgroundColor = R_UIThemeColor
        btn.setTitle("登录", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: ViewStyle.loginBtnFontSize)
        return btn
    }()
    
    lazy var forgetPwdBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("忘记密码?", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: ViewStyle.forgetBtnFontSize)
        btn.setTitleColor(R_UIThemeColor, for: UIControlState.normal)
        return btn
    }()
    
    // MARK: - OverrideMethod
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addAllSubViews()
        self.setSubviewConstraint()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LoginView {
    
    
    // MARK: - Private Method
    func addAllSubViews() {
        
        self.addSubview(phoneTextView)
        self.addSubview(pwdTextView)
        self.addSubview(loginBtn)
        self.addSubview(forgetPwdBtn)
        
    }
    
    func setSubviewConstraint() {
        
        self.phoneTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(ViewStyle.leftSpace)
            make.right.equalTo(self.snp.right).offset(-ViewStyle.leftSpace)
            make.top.equalTo(self.snp.top).offset(ViewStyle.topSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.pwdTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneTextView.snp.left)
            make.right.equalTo(self.phoneTextView.snp.right)
            make.top.equalTo(self.phoneTextView.snp.bottom).offset(ViewStyle.interSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.loginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneTextView.snp.left)
            make.right.equalTo(self.phoneTextView.snp.right)
            make.top.equalTo(self.pwdTextView.snp.bottom).offset(ViewStyle.topSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.forgetPwdBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.phoneTextView)
            make.width.equalTo(self.phoneTextView.snp.width).multipliedBy(0.4)
            make.top.equalTo(self.loginBtn.snp.bottom).offset(ViewStyle.interSpace)
            make.height.equalTo(ViewStyle.textViewHeight + 10)
        }
                
        self.layoutIfNeeded()
        
    }

}

extension LoginView {
    
    func switchSecurityMode(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            pwdTextView.textField.isSecureTextEntry = false
        } else {
            pwdTextView.textField.isSecureTextEntry = true
        }
    }
    
    
}
