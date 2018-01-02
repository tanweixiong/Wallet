//
//  ReceivablesCodeVC.swift
//  Wallet
//
//  Created by tam on 2017/9/14.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class ReceivablesCodeVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var copyAddressButton: UIButton!
    @IBOutlet weak var iconNameLabel: UILabel!
    
    @IBOutlet weak var codeView: UIView!
    
    let imageBackgroundSize:CGFloat = 50
    
    fileprivate let hornImageBgSize:CGFloat = 60
    
    fileprivate let hornImageSize:CGFloat = 55
    
    fileprivate var userId:String = ""
    var coin_no:String = ""
    
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
        self.userIdLabel.text = "--"
        
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
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(ReceivablesCodeVC.longTap))
        codeView.addGestureRecognizer(longTap)
        
        self.getData()
    }
    
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let coin_no = self.coin_no
        let parameters:[String:Any] = ["user_id":user_id,"coin_no":coin_no]
        SVProgressHUD.show(withStatus: "请稍等")
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIWalletTheWallet, parameters: parameters, showIndicator: true, success: { (json) in
            SVProgressHUD.dismiss()
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == 100 {
                  let data = json as! NSDictionary
                  let address = data["data"] as! String
                  self.userIdLabel.text = address
                  if coin_no == "0" {
                    let qrCodeString = "\(R_Theme_QRCode):\(address)?amount=0&type=2"
                    let image = Tools.createQRForString(qrString: qrCodeString, qrImageName: "iTunesArtwork")
                    self.QRCodeImageView.image = image
                  }else{
                    let image = Tools.createQRForString(qrString: address, qrImageName: "iTunesArtwork")
                    self.QRCodeImageView.image = image
                  }
                }else{
                    SVProgressHUD.showInfo(withStatus: "请重新登录")
                    LoginVC.switchRootVCToLoginVC()
                }
            }
        }) { (error) in
        }
    }
    
    func longTap(){
        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "Copy_successful"))
        let pasteboard = UIPasteboard.general
        pasteboard.string = UserDefaults.standard.getUserInfo().userId
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let qrCodeString = "\(R_Theme_QRCode):\(userId)?amount=\(textField.text!)&type=2"
//        let image = Tools.createQRForString(qrString: qrCodeString, qrImageName: "iTunesArtwork")
//        QRCodeImageView.image = image
//        return true
//    }

    @IBAction func copyAddressOnClick(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = userId
        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "copyed_address"))
    }
    
    @IBAction func backOnClick(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navBarBgAlpha = "1"
        self.navigationController?.popViewController(animated: true)
        SVProgressHUD.dismiss()
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
