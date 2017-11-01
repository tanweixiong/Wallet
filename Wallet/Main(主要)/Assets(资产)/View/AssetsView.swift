//
//  AssetsView.swift
//  Wallet
//
//  Created by tam on 2017/8/24.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class AssetsView: UIView {
    
    var userIDString:String = ""
    
    var assetsViewBlock:((String)->())?;
    
    struct AssetsViewUX {
        static let hornViewSize :CGFloat = XMAKE(45)
        static let hornImageSize :CGFloat = XMAKE(50)
    
        static let nameLabelHeight :CGFloat = YMAKE(14)
        static let contentLabelHeight :CGFloat = YMAKE(12)
        static let asssetsHeight :CGFloat = YMAKE(25)
        static let sumAsssetsHeight :CGFloat = YMAKE(13)
        
        static let qrCodeImageSize :CGFloat = 15.0
        static let qrViewSize = CGSize.init(width: 260, height: 260)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
        nameLabel.text = ""
        contentLabel.text = ""
        asssetsLabel.text = "≈0"
        sumAssetsLabel.text = LanguageHelper.getString(key: "assets")
        
        self.addSubview(hornImageViewBg)
        hornImageViewBg.addSubview(hornImageView)
        
        //创建二维码图片
        let userId = UserDefaults.standard.getUserInfo().userId
        let phone = UserDefaults.standard.getUserInfo().phone
        let qrCodeString = "\(R_Theme_QRCode):\(userId):\(phone)"
        let image = Tools.createQRForString(qrString: qrCodeString, qrImageName: "")
        qrCodeImageView.image = image
        
        self.addSubview(nameLabel)
        self.addSubview(contentLabel)
        self.addSubview(asssetsLabel)
        self.addSubview(sumAssetsLabel)
        self.addSubview(qrCodeImageView)
        
        self.addSubview(qrCodeButton)
        hornImageViewBg.addSubview(hornButton)
        
        hornImageViewBg.snp.makeConstraints { (make) in
            make.top.equalTo(YMAKE(10))
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(AssetsViewUX.hornViewSize)
        }
        
        hornImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(hornImageViewBg.snp.centerX)
            make.centerY.equalTo(hornImageViewBg.snp.centerY)
            make.size.equalTo(AssetsViewUX.hornImageSize)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hornImageView.snp.bottom).offset(YMAKE(5))
            make.centerX.equalTo(hornImageView.snp.centerX)
            make.width.equalTo(self.frame.size.width)
            make.height.equalTo(AssetsViewUX.nameLabelHeight)
        }
        
        let user_Id = UserDefaults.standard.getUserInfo().userId
        contentLabel.text = user_Id
        let size = contentLabel.getStringSize(text: contentLabel.text!, size: CGSize(width:SCREEN_WIDTH,height:AssetsViewUX.contentLabelHeight), font: AssetsViewUX.contentLabelHeight)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(YMAKE(5))
            make.centerX.equalTo(hornImageView.snp.centerX)
            make.width.equalTo(size.width + 1)
            make.height.equalTo(AssetsViewUX.contentLabelHeight)
        }
        
        asssetsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(YMAKE(10))
            make.centerX.equalTo(hornImageView.snp.centerX)
            make.width.equalTo(self.frame.size.width)
            make.height.equalTo(AssetsViewUX.asssetsHeight)
        }
        
        sumAssetsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(asssetsLabel.snp.bottom).offset(YMAKE(10))
            make.centerX.equalTo(hornImageView.snp.centerX)
            make.width.equalTo(self.frame.size.width)
            make.height.equalTo(AssetsViewUX.sumAsssetsHeight)
        }
        
        hornButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(hornImageViewBg.snp.centerX)
            make.centerY.equalTo(hornImageViewBg.snp.centerY)
            make.width.equalTo(AssetsViewUX.hornViewSize)
            make.height.equalTo(AssetsViewUX.hornViewSize)
        }
        
        qrCodeImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentLabel.snp.centerY)
            make.left.equalTo(contentLabel.snp.right)
            make.width.equalTo(AssetsViewUX.qrCodeImageSize)
            make.height.equalTo(AssetsViewUX.qrCodeImageSize)
        }
        
        qrCodeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(qrCodeImageView.snp.centerY)
            make.centerX.equalTo(qrCodeImageView.snp.centerX)
            make.width.equalTo(AssetsViewUX.qrCodeImageSize + 10)
            make.height.equalTo(AssetsViewUX.qrCodeImageSize + 10)
        }
        
        qrCodeButton.addTarget(self, action: #selector(displayOnClick), for: .touchUpInside)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(AssetsView.longTap))
        qrView.addGestureRecognizer(longTap)
    }
    
    func changeAvatar(){
        if self.assetsViewBlock != nil {
            self.assetsViewBlock!(self.userIDString);
        }
    }
    
    func displayOnClick() {
        self.addQRCodeView()
    }
    
    lazy var hornImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = AssetsViewUX.hornImageSize/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var hornImageViewBg :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = AssetsViewUX.hornViewSize/2
        view.clipsToBounds = true
       return view
    }()
    
    lazy var hornButton :UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.layer.cornerRadius = AssetsViewUX.hornViewSize/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(AssetsView.changeAvatar), for: .touchUpInside)
        return button
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x436071)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: AssetsViewUX.nameLabelHeight)
        return label
    }()
    
    lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x6793ab)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: AssetsViewUX.contentLabelHeight)
        return label
    }()
    
    lazy var asssetsLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x436071)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: AssetsViewUX.asssetsHeight)
        return label
    }()
    
    lazy var sumAssetsLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x436071)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: AssetsViewUX.sumAsssetsHeight)
        return label
    }()
    
    lazy var qrCodeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var qrCodeImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var qrView: QRCodeImageView = {
        let view = Bundle.main.loadNibNamed("QRCodeImageView", owner: nil, options: nil)?[0] as! QRCodeImageView
        let userId = UserDefaults.standard.getUserInfo().userId
        let phone = UserDefaults.standard.getUserInfo().phone
        let image = Tools.createQRForString(qrString: "\(R_Theme_QRCode):\(userId)?type=1", qrImageName: "iTunesArtwork")
        view.imageView.image = image
        view.desLabel.text = LanguageHelper.getString(key: "my_qr_code")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = R_UIThemeColor
        return view
    }()
    
    func longTap() {
        SVProgressHUD.showInfo(withStatus: "复制成功")
        let pasteboard = UIPasteboard.general
        pasteboard.string = UserDefaults.standard.getUserInfo().userId
    }
    
    func addQRCodeView() {
        UIApplication.shared.keyWindow?.addSubview(self.coverView)
        self.coverView.addSubview(self.qrView)
        self.coverView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(qrCoverViewTapped))
        self.coverView.addGestureRecognizer(tapGes)
        self.coverView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo((UIApplication.shared.keyWindow)!)
        }
        self.qrView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.coverView.snp.bottom).offset(-120)
            make.centerX.equalTo(self.coverView)
            make.size.equalTo(AssetsViewUX.qrViewSize)
        }
        self.coverView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.qrView.snp.remakeConstraints({ (make) in
                make.center.equalTo(self.coverView)
                make.size.equalTo(AssetsViewUX.qrViewSize)
            })
            self.coverView.layoutIfNeeded()
        }
    }
    
    func removeQRCodeView() {
        UIView.animate(withDuration: 0.5) {
            self.qrView.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self.coverView.snp.bottom).offset(-120)
                make.centerX.equalTo(self.coverView)
                make.size.equalTo(AssetsViewUX.qrViewSize)
            })
            self.coverView.layoutIfNeeded()
        }
        self.coverView.removeFromSuperview()
        self.qrView.removeFromSuperview()
    }
    
    func qrCoverViewTapped() {
        self.removeQRCodeView()
    }
}
