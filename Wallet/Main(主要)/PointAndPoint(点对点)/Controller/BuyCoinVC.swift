//
//  BuyCoinVC.swift
//  Wallet
//
//  Created by tam on 2017/10/9.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
//import EaseUI

class BuyCoinVC: WLMainViewController,UIScrollViewDelegate {
    
    struct BuyCoinUX {
        static let buyCoinHeight:CGFloat = 45
    }
    
    fileprivate lazy var viewModel: BuyCointVM = BuyCointVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "购买币"
        self.addDefaultBackBarButtonLeft()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(buyCoinVw)
        scrollView.addSubview(self.coinView)

        viewModel.loadDataWithHandler {[weak self] (loadState) in
            guard let `self` = self else { return }
            switch loadState {
            case .success:
                self.coinView.dataModel = self.viewModel.data
            default: break
            }
        }
    }
    
    func buyHandle(){
//        let chatController = EaseMessageViewController(conversationChatter: "tanweixiong", conversationType: EMConversationType(rawValue: 0))! 
//        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
   fileprivate(set) lazy var coinView:BuyCoinUserInfoVw = {
        let view = Bundle.main.loadNibNamed("BuyCoinUserInfoVw", owner: nil, options: nil)?[0] as! BuyCoinUserInfoVw
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 582)
        return view
    }()
    
   fileprivate(set) lazy var buyCoinVw: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: self.scrollView.frame.height, width: SCREEN_WIDTH, height: BuyCoinUX.buyCoinHeight)
        view.addSubview(self.contactButton)
        view.addSubview(self.buyButton)
        return view
    }()
    
    fileprivate(set) lazy var contactButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2, height: BuyCoinUX.buyCoinHeight))
       button.setTitle("联系对方", for: .normal)
       button.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x5174B0), for: .normal)
       button.addTarget(self, action: #selector(BuyCoinVC.buyHandle), for: .touchUpInside)
       button.tag = 1
       return button
    }()
    
    fileprivate(set) lazy var buyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: SCREEN_WIDTH/2, y:0, width: SCREEN_WIDTH/2, height: BuyCoinUX.buyCoinHeight))
        button.setTitle("购买", for: .normal)
        button.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x5174B0)
        button.addTarget(self, action: #selector(BuyCoinVC.buyHandle), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.tag = 2
        return button
    }()
    
    /// 懒加载
    fileprivate(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - BuyCoinUX.buyCoinHeight - 64))
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.clipsToBounds = true
        //        pagingEnabled = false
        // 预设定
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
//        scrollView.backgroundColor = UIColor.black
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: self.coinView.frame.height)
        return scrollView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
