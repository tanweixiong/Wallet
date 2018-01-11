//
//  TPTabBarController.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/8.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class WLTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //默认
        let normalArray = ["zichann","hangqn","faxiann","gerenn","jinrongn"]
        
        //选中后
        let selectedArray = ["zichan","hangq","faxian","geren","jinrong"]
        
        
        //标题文字
        let title = [LanguageHelper.getString(key: "home"),LanguageHelper.getString(key: "markets"),LanguageHelper.getString(key: "information"),LanguageHelper.getString(key: "user_center"),LanguageHelper.getString(key: "transaction")]
    
        //首页
        let storePlatformVC = AssetsVC();
        let storePlatformNavigationVC = WLNavigationController(rootViewController: storePlatformVC);
        storePlatformNavigationVC.tabBarItem.title = title[0];
        storePlatformNavigationVC.tabBarItem.image=UIImage(named: normalArray[0])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        storePlatformNavigationVC.tabBarItem.selectedImage=UIImage(named: selectedArray[0])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        //资讯页面
        let informationVC = IndustryVC();
        let informationNavigationVC = WLNavigationController(rootViewController: informationVC);
        informationNavigationVC.tabBarItem.title = title[1];
        informationNavigationVC.tabBarItem.image=UIImage(named: normalArray[1])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        informationNavigationVC.tabBarItem.selectedImage=UIImage(named: selectedArray[1])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        //交易页面
        let coinTransactionVC = FindVC();
        let coinTransactionNavigationVC = WLNavigationController(rootViewController: coinTransactionVC);
        coinTransactionNavigationVC.tabBarItem.title = title[2];
        coinTransactionNavigationVC.tabBarItem.image=UIImage(named: normalArray[2])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        coinTransactionNavigationVC.tabBarItem.selectedImage=UIImage(named: selectedArray[2])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        //我的页面
        let mineVC = PersonalVC();
        let mineNavigationVC = WLNavigationController(rootViewController: mineVC);
        mineNavigationVC.tabBarItem.title = title[3];
        mineNavigationVC.tabBarItem.image=UIImage(named: normalArray[3])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        mineNavigationVC.tabBarItem.selectedImage=UIImage(named: selectedArray[3])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        //交易界面
        let salesCoinVC = SalesCoinVC()
        let salesNavigationVC = WLNavigationController(rootViewController: salesCoinVC);
        salesNavigationVC.tabBarItem.title = title[4];
        salesNavigationVC.tabBarItem.image=UIImage(named: normalArray[4])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        salesNavigationVC.tabBarItem.selectedImage=UIImage(named: selectedArray[4])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        let items=[storePlatformNavigationVC,informationNavigationVC,salesNavigationVC,coinTransactionNavigationVC,mineNavigationVC];
        self.viewControllers=items;
//        self.navigationController?.navigationBar.tintColor=UIColor.white
        //.自定义工具栏
//        self.tabBar.backgroundColor=UIColor.clear
        //底部工具栏背景颜色
//        self.tabBar.barTintColor=UIColor.R_UIColorFromRGB(color: 0x333333)
//        self.tabBar.shadowImage = UIImage()
//        self.tabBar.backgroundImage = UIImage.creatImageWithColor(color: UIColor.R_UIRGBColor(red: 246, green: 246, blue: 246, alpha: 1), size: CGSize(width:SCREEN_WIDTH,height:44), alpha: 1)
        
        //.设置底部工具栏文字颜色（默认状态和选中状态）
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:UIColor.R_UIColorFromRGB(color: 0x666666), forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:.normal);
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:R_UIThemeColor, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:.selected)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
