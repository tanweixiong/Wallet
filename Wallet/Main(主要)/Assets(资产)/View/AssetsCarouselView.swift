//
//  AssetsCarouselView.swift
//  Wallet
//
//  Created by tam on 2017/8/24.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class AssetsCarouselView: UIView,UIScrollViewDelegate {
    
    fileprivate let dataSouce :NSArray = ["","","",""]
    fileprivate let SPACE :CGFloat = 5
    fileprivate let WIDTH :CGFloat = SCREEN_WIDTH - XMAKE(40)
    fileprivate let anymoreWidth: CGFloat = 38
    fileprivate let anymoreHeight: CGFloat = 30
    fileprivate let assetsViewTag =   1000000
    fileprivate let asssetsLabelTag = 2000000
    
    var assetsCarouselBlock:((UIButton)->())?;
    var assetsCarouselHeadBlock:((String,Int)->())?;
    
    init(frame: CGRect,dataArray: Array<Any>,isFirst:Bool){
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AssetsCarouselView.AssetsCarouselViewDeloadData(_:)), name: NSNotification.Name(rawValue: R_AssetsReloadAssetsMassage), object: nil)
        
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "kejitu")
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(backgroundImageView)
        
        let  height:CGFloat = YMAKE(165)
        let  top:CGFloat = YMAKE(70)
        
        let count = isFirst == true ? 1 : dataArray.count - 1
        if isFirst {
            for item in 0...1 {
                let view = AssetsView(frame: CGRect(x: (CGFloat(item) * WIDTH) + SPACE, y: top, width: WIDTH - SPACE * 2, height: height))
                view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 0.7)
                view.clipsToBounds = true
                view.layer.cornerRadius = 8
                scrollView.addSubview(view)
            }
        }else{
            for item in 0...dataArray.count - 1 {
                let view = AssetsView(frame: CGRect(x: (CGFloat(item) * WIDTH) + SPACE, y: top, width: WIDTH - SPACE * 2, height: height))
                view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 0.7)
                view.clipsToBounds = true
                view.layer.cornerRadius = 8
                view.tag = assetsViewTag + item
                view.assetsViewBlock = { (str:String) in
                    //返回点击的头像
                    if (self.assetsCarouselHeadBlock != nil) {
                        self.assetsCarouselHeadBlock!(str,view.tag)
                    }
                }
                scrollView.addSubview(view)
                
                let model = dataArray[item] as! AssetsListModel
                view.nameLabel.text = model.username
                view.contentLabel.text = model.userId
                view.asssetsLabel.text = model.allmoney?.stringValue
                view.userIDString = model.userId!
                
                view.asssetsLabel.tag = asssetsLabelTag + item
                
                let urlStr:String = model.userphoto!
                view.hornImageView.sd_setImage(with: NSURL(string: urlStr)! as URL, placeholderImage: UIImage.init(named: "morentouxiang"))
            }
        }
        
        scrollView.frame = CGRect(x: XMAKE(20), y: 0, width: WIDTH, height: frame.size.height)
        scrollView.contentSize = CGSize(width: WIDTH * CGFloat(count), height: frame.size.height)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.addSubview(scrollView)
        
        self.anymoreButton.frame = CGRect(x: SCREEN_WIDTH - XMAKE(20) - anymoreWidth, y: self.frame.size.height - YMAKE(20) - anymoreHeight, width: anymoreWidth, height: anymoreHeight)
        self.anymoreButton.addTarget(self, action: #selector(anymoreOnClick(_:)), for: .touchUpInside)
        self.addSubview(anymoreButton)
        
    }

    func setAvatar(_ item:Int,_ url:String){
        let view = self.scrollView.viewWithTag(item) as! AssetsView
        view.hornImageView.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: UIImage.init(named: "morentouxiang"))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func anymoreOnClick(_ sender:UIButton) {
        if self.assetsCarouselBlock != nil {
            self.assetsCarouselBlock!(sender);
        }
    }
    
    func AssetsCarouselViewDeloadData(_ sender:NSNotification){
        let array:NSArray = sender.object as! NSArray
        for index in 0...array.count - 1 {
            let model = array[index] as! AssetsListModel
            let assetsView = self.scrollView.subviews.first as! AssetsView
            assetsView.asssetsLabel.text = model.allmoney?.stringValue
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_AssetsReloadAssetsMassage), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.clipsToBounds = false;
        scrollView.bounces = false;
        return scrollView
    }()
    
    lazy var anymoreButton:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.init(named: "duobianx"), for: .normal)
        return button
    }()
}
