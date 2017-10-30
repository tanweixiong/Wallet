//
//  ForgetPwdView.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/14.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

class ForgetPwdView: UIView {

    fileprivate struct ViewStyle {
        static let topSpace: CGFloat = 40
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
        view.addTextFieldAndRightBtn(viewType: LoginTextfieldViewType.DefaultType)
        view.leftImageView.image = UIImage.init(named: "shouji")
        view.textField.setKeyboardStyle(textType: .TextFieldIntegerNumber)
        view.textField.placeholder = LanguageHelper.getString(key: "enter_phone")
        return view
    }()
    
    lazy var authorizeTextView: LoginTextFieldView = {
        let view = LoginTextFieldView()
        view.addTextFieldAndRightBtn(viewType: LoginTextfieldViewType.SecondsCountType)
        view.rightAutorBtn.setTitle(LanguageHelper.getString(key: "get_code"), for: UIControlState.normal)
        view.rightAutorBtn.setTitleColor(R_UIThemeColor, for: UIControlState.normal)
        view.rightAutorBtn.titleLabel?.font = UIFont.systemFont(ofSize: ViewStyle.forgetBtnFontSize)
        view.leftImageView.image = UIImage.init(named: "yanzhengma")
        view.textField.setKeyboardStyle(textType: .TextFieldIntegerNumber)
        view.textField.placeholder = LanguageHelper.getString(key: "register_code")
        return view
    }()
    
    lazy var pwdTextView: LoginTextFieldView = {
        let view = LoginTextFieldView()
        view.addTextFieldAndRightBtn(viewType: LoginTextfieldViewType.DefaultType)
        view.leftImageView.image = UIImage.init(named: "mima")
        view.textField.setKeyboardStyle(textType: .TextFieldNumberLetter)
        view.textField.placeholder = LanguageHelper.getString(key: "enter_new_pwd")
        return view
    }()
    
    lazy var confirmPwdTextView: LoginTextFieldView = {
        let view = LoginTextFieldView()
        view.addTextFieldAndRightBtn(viewType: LoginTextfieldViewType.DefaultType)
        view.leftImageView.image = UIImage.init(named: "queren")
        view.textField.setKeyboardStyle(textType: .TextFieldNumberLetter)
        view.textField.placeholder = LanguageHelper.getString(key: "enter_confirm_password")
        return view
    }()

    
    lazy var registerBtn: UIButton = {
        let btn = UIButton.setBtnBoarderCorner(radius: ViewStyle.btnRadius)
        btn.backgroundColor = R_UIThemeColor
        btn.setTitle(LanguageHelper.getString(key: "confirm"), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: ViewStyle.loginBtnFontSize)
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
    
    // MARK: - Private Method
    func addAllSubViews() {
        
        self.addSubview(phoneTextView)
        self.addSubview(authorizeTextView)
        self.addSubview(pwdTextView)
        self.addSubview(confirmPwdTextView)
        self.addSubview(registerBtn)
        
    }
    
    func setSubviewConstraint() {
        
        self.phoneTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(ViewStyle.leftSpace)
            make.right.equalTo(self.snp.right).offset(-ViewStyle.leftSpace)
            make.top.equalTo(self.snp.top).offset(ViewStyle.topSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.authorizeTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneTextView.snp.left)
            make.right.equalTo(self.phoneTextView.snp.right)
            make.top.equalTo(self.phoneTextView.snp.bottom).offset(ViewStyle.interSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.pwdTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneTextView.snp.left)
            make.right.equalTo(self.phoneTextView.snp.right)
            make.top.equalTo(self.authorizeTextView.snp.bottom).offset(ViewStyle.interSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.confirmPwdTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneTextView.snp.left)
            make.right.equalTo(self.phoneTextView.snp.right)
            make.top.equalTo(self.pwdTextView.snp.bottom).offset(ViewStyle.interSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.registerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneTextView.snp.left)
            make.right.equalTo(self.phoneTextView.snp.right)
            make.top.equalTo(self.confirmPwdTextView.snp.bottom).offset(ViewStyle.topSpace)
            make.height.equalTo(ViewStyle.textViewHeight + 10)
        }
        
        self.layoutIfNeeded()
        
    }
}
