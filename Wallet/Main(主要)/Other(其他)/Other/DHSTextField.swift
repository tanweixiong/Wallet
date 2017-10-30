//
//  DHSTextField.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/13.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

enum DHSTextFieldType {
    case TextFieldNormal  //正常模式
    case TextFieldNumberLetter  //数字字母模式
    case TextFieldIntegerNumber  //整数数字模式
    case TextFieldDecimalNumber //小数数字模式
    case TextFieldPaymentNumber //支付密码模式
    case TextFieldMall //邮箱注册
}

let kFilterNumber: String = "1234567890"
let kFilterLetter: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

class DHSTextField: UITextField , UITextFieldDelegate {
    
    
    var minLength: NSInteger = 0
    var maxLength: NSInteger = 0
    
    var textType: DHSTextFieldType?
    
    var hasChangedView: Bool = false //标识是否改变的窗体位置
    var keyboardRect: CGRect = CGRect.zero //键盘位置

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initType()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initType()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }

    
    func initType() {
        hasChangedView = false
        
        self.delegate = self
        
        //self.addTarget(self, action: #selector(DHSTextField.checkInput(sender:)), for: .editingChanged)
        
        self.addTarget(self, action: #selector(DHSTextField.touchInput(sender:)), for: .editingDidBegin)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func setKeyboardStyle(textType: DHSTextFieldType) {
        
        self.textType = textType
        
        if textType == .TextFieldNormal {
            self.keyboardType = .default
        } else if textType == .TextFieldIntegerNumber {
            self.keyboardType = .numberPad
        } else if textType == .TextFieldDecimalNumber {
            self.keyboardType = .decimalPad
        } else if textType == .TextFieldNumberLetter {
            self.keyboardType = .asciiCapable
        }else if textType == .TextFieldPaymentNumber{
            self.keyboardType = .numberPad
        }else if textType == .TextFieldMall {
            self.keyboardType = .asciiCapable
        }
        self.returnKeyType = .done
        
    }
    
    func keyboardWillShown(notif: NSNotification) {
        
        let info: Dictionary = notif.userInfo!
        let value: NSValue = info[UIKeyboardFrameBeginUserInfoKey]! as! NSValue
        keyboardRect = value.cgRectValue
        self.touchInput(sender: self)
    }
    
    func keyboardWillHidden(notif: NSNotification) {
        
        if hasChangedView {
            hasChangedView = false
            let screenView: UIView = self.getScreenView()
            let movementDuration: CGFloat = 0.3
            UIView.beginAnimations("anim", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(TimeInterval(movementDuration))
            screenView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            UIView.commitAnimations()
        }
    }

    
    
    func checkInput(sender: Any) {
        
        if let type = self.textType {
            switch type {
            case .TextFieldIntegerNumber:
                self.filterNumber()
            case .TextFieldNumberLetter:
                self.filterNumberLetter()
            default:
                break
            }
        }
    }
    
    func touchInput(sender: Any) {
        
        if self.isFirstResponder && keyboardRect.origin.y > 0 && hasChangedView == false {
            let screenView = self.getScreenView()
            let absRect: CGRect = screenView.convert(self.frame, from: self)
            
            if (absRect.origin.y + absRect.size.height + 45) > (screenView.frame.size.height - keyboardRect.size.height) {
                hasChangedView = true
                
                let movementDuration: CGFloat = 0.3
                let movement = (screenView.frame.size.height-keyboardRect.size.height) - ( absRect.origin.y+absRect.size.height + 45 )
                UIView.beginAnimations("anim", context: nil)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.setAnimationDuration(TimeInterval(movementDuration))
                let y = screenView.frame.origin.y + movement
                screenView.frame.origin.y = y
                
                UIView.commitAnimations()
                
            }
            
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.textType == .TextFieldNormal || self.textType == .TextFieldMall {
            return true
        } else {
            
            var expression = ""
            
            if string == "" {
                return true
            } else {
                if self.textType == .TextFieldIntegerNumber {
                    expression = "^[0-9]{0,11}$"
                } else if self.textType == .TextFieldDecimalNumber {
                    expression = "^[0-9]+(.[0-9]{0,2})?$"
                } else if self.textType == .TextFieldNumberLetter {
                    expression = "^[0-9A-Za-z]{0,20}$"
                }else if self.textType == .TextFieldPaymentNumber{
                    expression = "^[0-9]{0,6}$"
                }
                
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
                let numberOfMatches = regex.numberOfMatches(in: newString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (newString as NSString).length))
                return (numberOfMatches != 0)
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }

    //只能数字
    func filterNumber() {
        
        /*
        let str: String? = self.text
        let newStr: String = ""
        for var i = 0 ; str! && i < str.lengthOfBytes(using: .utf8) && i < self.maxLength ; i += 1 {
            let find: String = str.substring(with: Range.init(uncheckedBounds: (lower: i, upper: 1))
            let range: Range = kFilterNumber.range(of: find)
            if range.lowerBound {
                
            }
        }
 */
        
    }
    
    //只能数字和密码，区分大小写
    func filterNumberLetter() {
        
    }
    
    func getScreenView() -> UIView {
        var view: UIView? = nil
        view = self.superview
        while (view != nil) && (view!.superview != nil) {
            view = view?.superview
        }
        return view!
    }
    
    func verifyLetter(str: String) -> Bool {
        
        return true
    }
    
    func isValid() -> Bool {
        
        return true
    }
}
