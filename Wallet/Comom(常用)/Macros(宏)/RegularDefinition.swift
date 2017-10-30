//
//  RegularDefinition.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/8.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import RxSwift

typealias DisposeBag = RxSwift.DisposeBag

let        SCREEN_WIDTH = UIScreen.main.bounds.size.width;

let        SCREEN_HEIGHT = UIScreen.main.bounds.size.height;

func       XMAKE(_ x: CGFloat) -> CGFloat {
    return x * UIScreen.main.bounds.size.width/375;
}

func       YMAKE(_ y: CGFloat) -> CGFloat {
    return y * UIScreen.main.bounds.size.height/667;
}

//环信AppKey
public let R_huangXinChatKey = "1163171010178071#ec"

//二维码标识
public let R_Theme_QRCode = "echain"

//K线图的地址
public let R_Theme_lineGraph = "http://10.0.0.11/dhs-wallet/"

//保存用户资料
public let R_UserInfo = "userInfo"

//行情key
public let R_UserDefaults_Market_Key = "UserDefaultsMarketKey"

//行情详情key
public let R_UserDefaults_Market_Details_Key = "UserDefaultsMarketDetailsKey"

//行情编辑key
public let R_UserDefaults_Market_Details_Edit_Key = "UserDefaultsMarketDetailsEditKey"

//校验是否已被登录
public let R_Theme_isLogin = "isLogin"

//校验是否已经选择了语言
public let R_Theme_isChooseLanguage = "isChooseLanguage"

//校验输入中文和英文
public let R_Languages = "Reality_Languages"

//头像
public let R_UIThemeColor = UIColor.R_UIColorFromRGB(color: 0x11d8c3)

//刷新资产信息
public let R_AssetsReloadAssetsMassage = "R_AssetsReloadAssetsMassage"

//头像
public let R_UIThemeAvatarKey = "AvatarKey"

//主题背景颜色
public let R_UIThemeBackgroundColor = UIColor.R_UIColorFromRGB(color: 0xf8fcfd)

//线条颜色
public let R_UILineColor = UIColor.R_UIColorFromRGB(color: 0xdddddd)

//浅色
public let R_UIFontLightColor = UIColor.R_UIColorFromRGB(color: 0x999999)

//深色
public let R_UIFontDarkColor = UIColor.R_UIColorFromRGB(color: 0x666666)

//更深色
public let R_UIFontMoreDarkColor = UIColor.R_UIColorFromRGB(color: 0x333333)


