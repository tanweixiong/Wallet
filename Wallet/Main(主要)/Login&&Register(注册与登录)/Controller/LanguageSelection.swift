//
//  LanguageSelection.swift
//  Wallet
//
//  Created by tam on 2017/10/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class LanguageSelection: UIViewController {

    struct LanguageSelectionUX {
        static let buttonHeight:CGFloat = 45
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.isHidden = true
        self.navBarBgAlpha = "0"
        
        view.addSubview(backgroundImageView)
        view.addSubview(firstButton)
        view.addSubview(secodButton)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(-64)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo((UIApplication.shared.keyWindow?.frame.height)! + 64)
        }
        
        firstButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.snp.centerY).offset(YMAKE(-60))
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(SCREEN_WIDTH - XMAKE(40))
            make.height.equalTo(LanguageSelectionUX.buttonHeight)
        }
        
        secodButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(firstButton.snp.bottom).offset(YMAKE(20))
            make.width.equalTo(firstButton.snp.width)
            make.height.equalTo(firstButton.snp.height)
        }
    }

    func chooseLanguage(_ sender:UIButton){
        var langeuage = ""
        if sender.tag == 1 {
            langeuage = "zh-Hans"
            LanguageHelper.shareInstance.setLanguage(langeuage: langeuage)
        }else{
            langeuage = "en"
            LanguageHelper.shareInstance.setLanguage(langeuage: langeuage)
        }
        UserDefaults.standard.set(langeuage, forKey: R_Languages)
        UserDefaults.standard.set(true, forKey: R_Theme_isChooseLanguage)
        let navi = WLNavigationController(rootViewController: LoginVC())
        UIApplication.shared.keyWindow?.rootViewController = navi
    }
    
    lazy var firstButton:UIButton = {
        let button = UIButton()
        button.setTitle("中文/Chinese", for: .normal)
        button.addTarget(self, action: #selector(chooseLanguage(_:)), for: .touchUpInside)
        button.tag = 1
        button.backgroundColor = UIColor.white
        button.setTitleColor(R_UIThemeColor, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    lazy var secodButton:UIButton = {
        let button = UIButton()
        button.setTitle("英文/English", for: .normal)
        button.addTarget(self, action: #selector(chooseLanguage(_:)), for: .touchUpInside)
        button.tag = 2
        button.backgroundColor = UIColor.white
        button.setTitleColor(R_UIThemeColor, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    lazy var backgroundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_loginbackground")
        return imageView
    }()
    
}
