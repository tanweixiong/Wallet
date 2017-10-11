//
//  ModifyPwdView.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/18.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

class ModifyPwdView: UIView {

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
    lazy var originPwdTextView: LoginTextFieldView = {
        let view = LoginTextFieldView()
        view.addTextFieldAndRightBtn(viewType: LoginTextfieldViewType.DefaultType)
        view.leftImageView.image = UIImage.init(named: "mima")
        view.textField.setKeyboardStyle(textType: .TextFieldNumberLetter)
        view.textField.placeholder = LanguageHelper.getString(key: "enter_older_password")
        return view
    }()
    
    lazy var newPwdTextView: LoginTextFieldView = {
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
    
    
    lazy var commitBtn: UIButton = {
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
        
        self.addSubview(originPwdTextView)
        self.addSubview(newPwdTextView)
        self.addSubview(confirmPwdTextView)
        self.addSubview(commitBtn)
        
    }
    
    func setSubviewConstraint() {
        
        self.originPwdTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(ViewStyle.leftSpace)
            make.right.equalTo(self.snp.right).offset(-ViewStyle.leftSpace)
            make.top.equalTo(self.snp.top).offset(ViewStyle.topSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
    
        
        self.newPwdTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.originPwdTextView.snp.left)
            make.right.equalTo(self.originPwdTextView.snp.right)
            make.top.equalTo(self.originPwdTextView.snp.bottom).offset(ViewStyle.interSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.confirmPwdTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.originPwdTextView.snp.left)
            make.right.equalTo(self.originPwdTextView.snp.right)
            make.top.equalTo(self.newPwdTextView.snp.bottom).offset(ViewStyle.interSpace)
            make.height.equalTo(ViewStyle.textViewHeight)
        }
        
        self.commitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.originPwdTextView.snp.left)
            make.right.equalTo(self.originPwdTextView.snp.right)
            make.top.equalTo(self.confirmPwdTextView.snp.bottom).offset(ViewStyle.topSpace)
            make.height.equalTo(ViewStyle.textViewHeight + 10)
        }
        
        self.layoutIfNeeded()
        
    }

}
