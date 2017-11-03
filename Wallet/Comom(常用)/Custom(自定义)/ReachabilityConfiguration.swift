//
//  ReachabilityConfiguration.swift
//  Wallet
//
//  Created by tam on 2017/11/3.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ReachabilitySwift

var reachability: Reachability?

class ReachabilityConfiguration: NSObject {
    
    // 检查检查网络状态是否当前网络可用
   class func checkNetworkStates() {
        reachability = Reachability.init()
        if reachability!.isReachableViaWiFi {
            print("连接类型：WiFi")
        } else if reachability!.isReachableViaWWAN {
            print("连接类型：移动网络")
        } else {
            print("连接类型：没有网络连接")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(ReachabilityConfiguration.reachabilityChanged(note:)),
            name: ReachabilityChangedNotification,
            object: reachability
        )
        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    //检测网络状况
   class func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.currentReachabilityStatus{
        case .reachableViaWiFi:
            print("Reachable via WiFi")
        case .reachableViaWWAN:
            print("Reachable via Cellular")
        case .notReachable:
            print("Network not reachable")
            ReachabilityConfiguration.connectHandle()
        }
    }
    
    class func connectHandle(){
        //8.0以上
        let alertView = UIAlertView()
        alertView.title = LanguageHelper.getString(key: "prompt")
        alertView.message = LanguageHelper.getString(key: "no_connect")
        alertView.addButton(withTitle: LanguageHelper.getString(key: "version_cancel"))
        alertView.addButton(withTitle: LanguageHelper.getString(key: "confirm"))
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
    }
}
