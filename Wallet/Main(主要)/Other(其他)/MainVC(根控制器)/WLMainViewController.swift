//
//  TPMainViewController.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/10.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class WLMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    //返回按钮点击响应
    func backToPrevious() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func rightImageBtn(_ sender:UIBarButtonItem) {
        
    }
    
    func leftImageBtn(_ sender:UIBarButtonItem) {
        
    }
    
    func rightTextBtn(_ sender:UIBarButtonItem) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WLMainViewController {
    
     func addDefaultBackBarButtonLeft() {
        let button =   UIButton(type: .custom)
        button.frame = CGRect(x:0, y:0, width:60, height:44)
        button.setImage(UIImage(named:"ic_navibar_back"), for: .normal)
        button.addTarget(self, action: #selector(backToPrevious), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0)
        let leftBarBtn = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    
    func addDefaultButtonTextRight(_ title:String) {
        let button =   UIButton(type: .custom)
        button.frame = CGRect(x:0, y:0, width:60, height:44)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(rightTextBtn(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        let leftBarBtn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = leftBarBtn
    }
    
    func addDefaultButtonImageRight(_ buttonImage:String) {
        let image = UIImage(named:buttonImage)?.withRenderingMode(.alwaysOriginal)
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightImageBtn(_ :)))
        self.navigationItem.rightBarButtonItem = item;
    }
    
    func addDefaultButtonImageLeft(_ buttonImage:String) {
        let image = UIImage(named:buttonImage)?.withRenderingMode(.alwaysOriginal)
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftImageBtn(_ :)))
        self.navigationItem.leftBarButtonItem = item;
    }
    
    func pushNextViewController(_ viewController:UIViewController,_ animated:Bool) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}
