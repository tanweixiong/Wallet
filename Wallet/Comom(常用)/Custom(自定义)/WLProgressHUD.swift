//
//  WLProgressHUD.swift
//  Wallet
//
//  Created by tam on 2017/8/29.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

open class WLProgressHUD: NSObject {
    open class func show() {
        SVProgressHUD.show(with: .none)
    }
    
    open class func displayATransparentFace() {
        SVProgressHUD.show(with: .clear)
    }
    
    open class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    open class func displayStatus(_ withStatus:String!) {
        SVProgressHUD.show(withStatus: withStatus)
    }
    
    open class func showSuccess(_ withStatus:String!) {
        SVProgressHUD.showSuccess(withStatus: withStatus)
    }
    
    open class func showError(_ withStatus:String!) {
        SVProgressHUD.showError(withStatus: withStatus)
    }
    
    open class func showInfo(_ withStatus:String!) {
        SVProgressHUD.showInfo(withStatus: withStatus)
    }
}

public func WLSuccess(_ title:String!) {
    WLProgressHUD.showSuccess(title)
}

public func WLError(_ title:String!) {
    WLProgressHUD.showError(title)
}

public func WLInfo(_ title:String!) {
    WLProgressHUD.showInfo(title)
}

public func WLWillLoad() {
    WLProgressHUD.show()
}

public func WLLoading(_ title:String!) {
    WLProgressHUD.displayStatus(title)
}

public func TZDismiss() {
    WLProgressHUD.dismiss()
}
