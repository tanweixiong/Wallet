//
//  ReceivablesCodeVC.swift
//  Wallet
//
//  Created by tam on 2017/9/14.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class ReceivablesCodeVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var copyAddressButton: UIButton!
    @IBOutlet weak var iconNameLabel: UILabel!
    
    let imageBackgroundSize:CGFloat = 50
    
    fileprivate let hornImageBgSize:CGFloat = 60
    
    fileprivate let hornImageSize:CGFloat = 55
    
    fileprivate var userId:String = ""
    
    var coinName = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setCloseRoundKeyboard()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconNameLabel.text = coinName
        
        userId = UserDefaults.standard.getUserInfo().userId
        let photo = UserDefaults.standard.getUserInfo().photo
        
        //二维码
        let qrCodeString = "\(R_Theme_QRCode):\(userId)?amount=0&type=2"
        let image = Tools.createQRForString(qrString: qrCodeString, qrImageName: "iTunesArtwork")
        QRCodeImageView.image = image
        
        //id
        userIdLabel.text = userId
        
        //头像
        hornImageView.sd_setImage(with: NSURL(string: photo)! as URL, placeholderImage: UIImage.init(named: "morentouxiang"))
        
        self.view.addSubview(hornImageViewBg)
        hornImageViewBg.addSubview(hornImageView)
        
        hornImageViewBg.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(backgroundVw.snp.top).offset(-hornImageBgSize/2)
            make.width.equalTo(hornImageBgSize)
            make.height.equalTo(hornImageBgSize)
        }
        
        hornImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(hornImageViewBg.snp.centerX)
            make.centerY.equalTo(hornImageViewBg.snp.centerY)
            make.width.equalTo(hornImageSize)
            make.height.equalTo(hornImageSize)
        }
        
        copyAddressButton.setTitle(LanguageHelper.getString(key: "copy_address"), for: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let qrCodeString = "\(R_Theme_QRCode):\(userId)?amount=\(textField.text!)&type=2"
        let image = Tools.createQRForString(qrString: qrCodeString, qrImageName: "iTunesArtwork")
        QRCodeImageView.image = image
        return true
    }

    @IBAction func copyAddressOnClick(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = userId
        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "copyed_address"))
    }
    
    @IBAction func backOnClick(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var hornImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "morentouxiang")
        imageView.layer.cornerRadius = self.hornImageSize/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var hornImageViewBg :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = self.hornImageBgSize/2
        view.clipsToBounds = true
        return view
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
