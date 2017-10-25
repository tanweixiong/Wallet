//
//  AppDelegate.swift
//  Wallet
//
//  Created by tam on 2017/8/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let sharedManger = AppDelegate()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.setLanguage()
//        self.chatSettings()
        self.addRootViewController()
        self.window?.backgroundColor = UIColor.white
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        return true
    }
    
    func addRootViewController() {
        if UserDefaults.standard.bool(forKey:R_Theme_isLogin) {
            let navi = WLTabBarController()
            self.window?.rootViewController = navi
        }else {
            if  UserDefaults.standard.bool(forKey:R_Theme_isChooseLanguage) {
                let navi = WLNavigationController(rootViewController: LoginVC())
                self.window?.rootViewController = navi
            }else{
                let navi = WLNavigationController(rootViewController: LanguageSelection())
                self.window?.rootViewController = navi
            }
        
        }
    }
    
    func setLanguage(){
        LanguageHelper.shareInstance.initUserLanguage()
        if (UserDefaults.standard.object(forKey: R_Languages) != nil) {
            let language = UserDefaults.standard.object(forKey: R_Languages)
            LanguageHelper.shareInstance.setLanguage(langeuage: language as! String)
        }
    }
    
//    func chatSettings(){
//        let options = EMOptions(appkey:R_huangXinChatKey)
//        options?.apnsCertName = "istore_dev"
//        EMClient.shared().initializeSDK(with: options)
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

