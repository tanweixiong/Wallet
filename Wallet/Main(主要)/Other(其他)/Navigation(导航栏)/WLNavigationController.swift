//
//  TPNavigationController.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/8.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SnapKit
import YYText

//导航栏的颜色
public let navigationColor:UIColor = R_UIThemeColor

class WLNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //导航栏
        self.navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage.creatImageWithColor(color: navigationColor, size: CGSize(width:SCREEN_WIDTH,height:64), alpha: 1), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        //全局键盘颜色
//        UITextView.appearance().keyboardAppearance = .light
//        UITextField.appearance().keyboardAppearance = .light
//        YYTextView.appearance().keyboardAppearance = .light
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
//            viewController.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        }else{
            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: true)
    }
}


