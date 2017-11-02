//
//  AutorizeButton.swift
//  DHSWallet
//  短信验证码按钮
//  Created by zhengyi on 2017/8/14.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

class AutorizeButton: UIButton {

    var countDownTimer: Timer?
    
    var remainingSeconds: Int = 0 {
        
        willSet {
            self.setTitle("\(newValue)\(LanguageHelper.getString(key: "Seconds_later"))", for: .normal)
            
            if newValue <= 0 {
                self.setTitle(LanguageHelper.getString(key: "Resend"), for: .normal)
                isCounting = false
            }
            
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AutorizeButton.updateTime(_:)), userInfo: nil, repeats: true)
                remainingSeconds = 59
                self.setTitleColor(UIColor.gray, for: .normal)
                countDownTimer?.fire()
            } else {
                countDownTimer?.invalidate()
                countDownTimer = nil
                self.setTitleColor(R_UIThemeColor, for: .normal)
            }
            
            self.isEnabled = !newValue
        }
    }
    
    func changeToOriginState() {
        
        self.remainingSeconds = 0
    }
    
    
    func updateTime(_ timer: Timer) {
        
        remainingSeconds -= 1
    }
    
    /*
    func buttonClick(_ sender: UIButton) {
        
        isCounting = true
        
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        countDownTimer?.invalidate()
        countDownTimer = nil
    }

}
