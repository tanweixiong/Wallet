//
//  LoginTextFieldView.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/10.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import SnapKit

public enum TextFieldType {
    case PhoneNumber
    case Password
    case Number
}

public enum LoginTextfieldViewType {
    case DefaultType //左侧有视图，右侧没有按钮
    case RightBtnType //右侧有按钮，可以相应
    case SecondsCountType //右侧时间倒计时按钮
}

class LoginTextFieldView: UIView , UITextFieldDelegate{
    
    // MARK: - Properties
    
    fileprivate struct ViewStyle {
        static let placeholderColor = UIColor.R_UIColorFromRGB(color: 0xE1E2E3)
        static let textFieldColor = UIColor.black
        static let contentFontSize: CGFloat = 14
        static let statusViewRatio: CGFloat = 1.93
        static let leftImageHeightRatio: CGFloat = 0.8
        static let rightBtnHeightRatio: CGFloat = 0.6
        static let leftPaddingSpace = 10
        static let bottomPaddingSpace = 5
        static let rightBtnWidthRatio = 0.3
    }
    
    public var loginTextfieldViewType: LoginTextfieldViewType?
    public var textType: TextFieldType?
    
    public var leftImageView = UIImageView()
    let textField = DHSTextField()
    public var rightBtn = UIButton()
    public var rightAutorBtn = AutorizeButton()
    fileprivate var bottomLine = UIView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addLeftImageAndBottomLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addLeftImageAndBottomLine()
    }
}


extension LoginTextFieldView {
    
    // MARK: - Private Method
    
    fileprivate func addLeftImageAndBottomLine() {
        
        self.addSubview(self.leftImageView)
        self.addSubview(self.bottomLine)
        self.addSubview(self.textField)
        self.textField.textColor = UIColor.black
        self.textField.font = UIFont.systemFont(ofSize: ViewStyle.contentFontSize)
        
        self.leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(ViewStyle.leftPaddingSpace)
            make.centerY.equalTo(self)
            make.width.height.equalTo(self.snp.height).multipliedBy(ViewStyle.leftImageHeightRatio)
        }
        
        self.bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(1)
        }
        
        self.backgroundColor = UIColor.white
        self.bottomLine.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xE1E2E3)
        self.isUserInteractionEnabled = true

    }
    
    public func addTextFieldAndRightBtn(viewType:LoginTextfieldViewType) {
        
        switch viewType {
        case LoginTextfieldViewType.DefaultType:
            
            self.textField.snp.makeConstraints({ (make) in
               make.left.equalTo(self.leftImageView.snp.right).offset(ViewStyle.bottomPaddingSpace)
               make.right.equalTo(self.snp.right).offset(ViewStyle.bottomPaddingSpace)
               make.centerY.equalTo(self)
               make.height.equalTo(self.leftImageView.snp.height).multipliedBy(0.7)
           })
            

        case LoginTextfieldViewType.RightBtnType:
            
            self.addSubview(self.rightBtn)
            
            self.textField.snp.makeConstraints({ (make) in
                make.left.equalTo(self.leftImageView.snp.right).offset(ViewStyle.bottomPaddingSpace)
                make.centerY.equalTo(self)
                make.height.equalTo(self.leftImageView.snp.height)
            })
            
            self.rightBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(self.textField.snp.right).offset(ViewStyle.bottomPaddingSpace)
                make.centerY.right.equalTo(self)
                make.right.equalTo(self.snp.right).offset(-ViewStyle.bottomPaddingSpace)
                make.height.width.equalTo(self.leftImageView.snp.height).multipliedBy(0.7)
            })
            
        case LoginTextfieldViewType.SecondsCountType:
            
            self.addSubview(self.rightAutorBtn)
            
            self.textField.snp.makeConstraints({ (make) in
                make.left.equalTo(self.leftImageView.snp.right).offset(ViewStyle.bottomPaddingSpace)
                make.centerY.equalTo(self)
                make.height.equalTo(self.leftImageView.snp.height)
            })
            
            self.rightAutorBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(self.textField.snp.right).offset(ViewStyle.bottomPaddingSpace)
                make.centerY.right.equalTo(self)
                make.height.equalTo(self.leftImageView.snp.height)
                make.right.equalTo(self.snp.right).offset(-ViewStyle.bottomPaddingSpace)
                make.width.equalTo(self.snp.width).multipliedBy(ViewStyle.rightBtnWidthRatio)
            })
        }
    }
}

extension LoginTextFieldView {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
