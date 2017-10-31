//
//  CreateMyWalletVC.swift
//  Wallet
//
//  Created by tam on 2017/10/31.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class CreateMyWalletVC: UIViewController,UIScrollViewDelegate {
    
    struct CreateMyWalletUX {
        static let tabBarHeight :CGFloat = 45
        static let backBtnRect  :CGRect = CGRect.init(x: 10, y: 20, width: 30, height: 30)
        static let scrollerHeight:CGFloat = SCREEN_HEIGHT - CreateMyWalletUX.tabBarHeight - 64 - 10
    }

    fileprivate let createMallWalletVC = CreateMallWalletVC()
    fileprivate let createWalletVC = CreateWalletVC()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = LanguageHelper.getString(key: "create_wallet")
        
        self.view.addSubview(topView)
        self.view.addSubview(tabBar)
        self.view.addSubview(scrollView)
        scrollView.addSubview(createWalletVC.view)
        scrollView.addSubview(createMallWalletVC.view)
        
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(0)
            make.height.equalTo(64)
        }
        
        tabBar.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(CreateMyWalletUX.tabBarHeight)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(tabBar.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(CreateMyWalletUX.scrollerHeight)
        }
        
        createWalletVC.view.snp.makeConstraints { (make) in
            make.left.equalTo(scrollView.snp.left)
            make.top.equalTo(scrollView.snp.top)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(scrollView.snp.height)
        }
        
        createMallWalletVC.view.snp.makeConstraints { (make) in
            make.left.equalTo(createWalletVC.view.snp.right)
            make.top.equalTo(scrollView.snp.top)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(scrollView.snp.height)
        }
    }
    
    lazy var tabBar: CreateMyWalletBar = {
        let view = Bundle.main.loadNibNamed("CreateMyWalletBar", owner: nil, options: nil)?.last as! CreateMyWalletBar
        view.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.R_UIRGBColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.createMyWalletBarCallBack = {(sender:UIButton) in
            if sender.tag == 1 {
               self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }else{
               self.scrollView.contentOffset = CGPoint(x: SCREEN_WIDTH, y: 0)
            }
        }
        return view
    }()
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.clipsToBounds = false;
        scrollView.bounces = false;
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: CreateMyWalletUX.scrollerHeight)
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    lazy var topView: UIView =  {
        let view = UIView(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: 64))
        view.backgroundColor = R_UIThemeColor
        let backBtn = UIButton(type: .custom)
        backBtn.setBackgroundImage(UIImage.init(named: "cuowu"), for: .normal)
        backBtn.frame = CreateMyWalletUX.backBtnRect
        backBtn.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        view.addSubview(backBtn)
        
        let label = UILabel(frame: CGRect(x: 0, y: 32, width: SCREEN_WIDTH, height: 18))
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "创建钱包"
        view.addSubview(label)
        return view
    }()
    
    func backToLogin(){
        self.dismiss(animated: true) {
        }
    }
    

}
