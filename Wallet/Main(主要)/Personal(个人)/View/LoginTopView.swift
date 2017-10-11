//
//  LoginTopView.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/10.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import SnapKit

public enum LoginTopViewType {
    case switchType
    case fixType
}

class LoginTopView: UIView {
    
    fileprivate struct ViewStyle {
        static let labelTextColor = UIColor.white
        static let textFieldColor = UIColor.black
        static let titleFontSize: CGFloat = 17
        static let contentFontSize: CGFloat = 14
        static let statusViewRatio: CGFloat = 1.93
        static let topImageSize: CGFloat = 60
        static let btnHeight: CGFloat = 50
        static let statusViewHeightRatio: CGFloat = 0.22
        static let backBtnRect: CGRect = CGRect.init(x: 10, y: 20, width: 30, height: 30)
    }
    
    // MARK: - Properties
    public var topImageView = UIImageView()
    public var topLoginBtn = UIButton()
    public var topRegisterBtn = UIButton()
    public  var topLoginStatusView = UIImageView()
    public var topRegisterStatusView = UIImageView()
    public var midLabel = UILabel()
    public var midStatusView = UIImageView()
    public var midTitle: String?
    public var viewType: LoginTopViewType?
    public var backBtn = UIButton()
    
    // MARK: - OverrideMethod
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addAllSubViews()
        self.setSubviewConstraint()
        self.setSubviewStyle()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - 视图设置
extension LoginTopView {
    
    fileprivate func addAllSubViews() {
        
        self.addSubview(topImageView)
        self.addSubview(topLoginStatusView)
        self.addSubview(topRegisterStatusView)
        self.addSubview(topLoginBtn)
        self.addSubview(topRegisterBtn)
        self.addSubview(midLabel)
        self.addSubview(midStatusView)
        self.addSubview(backBtn)
    }
    
    fileprivate func setSubviewConstraint() {
        
        self.topImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: ViewStyle.topImageSize, height: ViewStyle.topImageSize))
        }
        
        self.topLoginStatusView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.centerX.equalTo(topLoginBtn.snp.centerX)
            make.height.equalTo(topLoginBtn.snp.height).multipliedBy(ViewStyle.statusViewHeightRatio)
            make.width.equalTo(self.topLoginStatusView.snp.height).multipliedBy(ViewStyle.statusViewRatio)
        }
        
        self.topRegisterStatusView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.centerX.equalTo(topRegisterBtn.snp.centerX)
            make.height.equalTo(topRegisterBtn.snp.height).multipliedBy(ViewStyle.statusViewHeightRatio)
            make.width.equalTo(self.topRegisterStatusView.snp.height).multipliedBy(ViewStyle.statusViewRatio)

        }
        
        self.topLoginBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(ViewStyle.btnHeight)
        }
        
        self.topRegisterBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(ViewStyle.btnHeight)
        }
        
        self.midLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH).multipliedBy(0.5)
            make.height.equalTo(ViewStyle.btnHeight)
        }
        
        self.midStatusView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
            make.height.equalTo(topRegisterBtn.snp.height).multipliedBy(ViewStyle.statusViewHeightRatio)
            make.width.equalTo(self.midStatusView.snp.height).multipliedBy(ViewStyle.statusViewRatio)
        }
        
        self.backBtn.snp.makeConstraints { (make) in
            make.size.equalTo(ViewStyle.backBtnRect.size)
            make.left.equalTo(ViewStyle.backBtnRect.origin.x)
            make.top.equalTo(ViewStyle.backBtnRect.origin.y)
        }
        
    }
    
    fileprivate func setSubviewStyle() {
        
        self.backgroundColor = R_UIThemeColor
        topImageView.image = UIImage.init(named: "ren")
        topLoginStatusView.image = UIImage.init(named: "baissanjiao")
        topRegisterStatusView.image = UIImage.init(named: "baissanjiao")
        midStatusView.image = UIImage.init(named: "baissanjiao")
        
        topLoginBtn.setTitle("登录", for: UIControlState.normal)
        topLoginBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xE1E2E3), for: UIControlState.normal)
        topLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: ViewStyle.titleFontSize)
        topLoginBtn.setTitle("登录", for: UIControlState.selected)
        topLoginBtn.setTitleColor(UIColor.white, for: UIControlState.selected)
        
        topRegisterBtn.setTitle("注册", for: UIControlState.normal)
        topRegisterBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xE1E2E3), for: UIControlState.normal)
        topRegisterBtn.titleLabel?.font = UIFont.systemFont(ofSize: ViewStyle.titleFontSize)
        topRegisterBtn.setTitle("注册", for: UIControlState.selected)
        topRegisterBtn.setTitleColor(UIColor.white, for: UIControlState.selected)
        
        if let title = self.midTitle {
            midLabel.text = title
        } else {
            midLabel.text = ""
        }
        
        midLabel.textColor = UIColor.white
        midLabel.font = UIFont.systemFont(ofSize: ViewStyle.titleFontSize)
        midLabel.textAlignment = NSTextAlignment.center
        
        backBtn.setBackgroundImage(UIImage.init(named: "baifanhui"), for: .normal)
       
    }
    
    public func setBtnInitialStatus(viewType: LoginTopViewType) {
        
        self.viewType = viewType
        switch viewType {
        case .switchType:
            self.topLoginBtn.isSelected = true
            self.topRegisterStatusView.isHidden = true
            self.midStatusView.isHidden = true
            self.midLabel.isHidden = true
            self.backBtn.isHidden = true
        case .fixType:
            self.topLoginBtn.isHidden = true
            self.topLoginStatusView.isHidden = true
            self.topRegisterBtn.isHidden = true
            self.topRegisterStatusView.isHidden = true
            self.midLabel.text = self.midTitle
            self.backBtn.isHidden = false
        }
        
    }
    
    public func loginBtnShow(show:Bool) {
        
        self.topLoginBtn.isSelected = show
        self.topLoginStatusView.isHidden = !show
        
        self.topRegisterBtn.isSelected = !show
        self.topRegisterStatusView.isHidden = show
        
    }
}

// MARK: - 共有方法
