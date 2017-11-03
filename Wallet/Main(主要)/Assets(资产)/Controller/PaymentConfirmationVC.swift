//
//  PaymentConfirmationVC.swift
//  DHSWallet
//
//  Created by tam on 2017/9/5.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class PaymentConfirmationVC: WLMainViewController,ZCTradeViewDelegate {
    
    @IBOutlet weak var paymentConfirmationLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dhsLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    fileprivate let payeeFont = UIFont.systemFont(ofSize: 16)
    fileprivate let payeeTextColor = UIColor.R_UIColorFromRGB(color: 0x333333)
    fileprivate let corner:CGFloat = 5
    @IBOutlet weak var shoukuanLabel: UILabel!
    @IBOutlet weak var sumAmountLabel: UILabel!
    @IBOutlet weak var comfirmButton: UIButton!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var remarksScroller: UIScrollView!

    @IBOutlet weak var remarkLLabel: UILabel!
    var payee:String = ""
    var dhs:String = ""
    var totalAmount:String = ""
    var serviceCharge:String = ""
    var serialNumber:String = ""
    var remark:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "transfer_confirm")
        self.addDefaultBackBarButtonLeft()
        payeeLabel.text = payee
        dhsLabel.text = dhs
        remarkLabel.text = remark
        totalAmountLabel.text =  totalAmount
        paymentConfirmationLabel.text = LanguageHelper.getString(key: "Payment_Confirmation")
        serviceChargeLabel.text = LanguageHelper.getString(key: "service_charge") + ":" + serviceCharge
        shoukuanLabel.text = LanguageHelper.getString(key: "receipt") + ":"
        sumAmountLabel.text =  LanguageHelper.getString(key: "transaction_amount") + ":"
        comfirmButton.setTitle(LanguageHelper.getString(key: "confirm"), for: .normal)
        remarkLLabel.text = LanguageHelper.getString(key: "remark") + ":"
        self.createUI()
    }
    
    func createUI()  {
        scrollView.addSubview(payeeLabel)
        let size = payeeLabel.getStringSize(text: payeeLabel.text!, size: CGSize(width: CGFloat(MAXFLOAT), height:dhsLabel.frame.height))
        payeeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(shoukuanLabel.snp.centerY)
            make.left.equalTo(0)
            make.width.height.equalTo(size)
        }
        scrollView.contentSize = CGSize(width: size.width, height: scrollView.frame.size.height)
        
        remarksScroller.addSubview(remarkLabel)
        let remarkSize = remarkLabel.getStringSize(text: remarkLabel.text!, size: CGSize(width: CGFloat(MAXFLOAT), height:dhsLabel.frame.height))
        remarkLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(remarksScroller.snp.centerY)
            make.left.equalTo(remarksScroller.snp.left)
            make.width.equalTo(remarkSize.width)
            make.height.equalTo(remarkSize.height)
        }
        remarksScroller.contentSize = CGSize(width: remarkSize.width, height: remarksScroller.frame.size.height)
        
        
        //设置圆角
        backgroundVw.layer.cornerRadius = corner
        backgroundVw.clipsToBounds = true
        
        comfirmButton.layer.cornerRadius = corner
        comfirmButton.clipsToBounds = true
    }
    
    func finish(_ pwd: String) -> String! {
        if checkInput() {
            let userId = UserDefaults.standard.getUserInfo().userId
            let payPassword = pwd
            let parameters = ["serialNumber":serialNumber,"payPassword":payPassword,"userId":userId]
            SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"), maskType: .black)
            NetWorkTool.request(requestType: .post, URLString:ConstAPI.kAPITrans, parameters: parameters, showIndicator: true, success: { (json) in
                SVProgressHUD.dismiss()
                let responseData = Mapper<PaymentConfirmationModel>().map(JSONObject: json)
                
                if let code = responseData?.code {
                    if code == "100" {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setReloadAssets"), object: nil)
                        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "successful_payment"))
                       self.navigationController?.popViewController(animated: true)
                    //设置支付密码
                    }else if code == "105" {
                        let vc = SettingPaypsdVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    //重新找回支付密码
                    }else if code == "104"{
                        let forgetPwdVC = ForgetPwdViewController()
                        forgetPwdVC.viewType = .getBackPayPwd
                        forgetPwdVC.topView.midLabel.text = LanguageHelper.getString(key: "find_password")
                        self.present(forgetPwdVC, animated: true) {
                        }
                    }else {
                        SVProgressHUD.showInfo(withStatus: responseData?.msg)
                    }
                }
                
            }) { (error) in
                 SVProgressHUD.dismiss()
            }
        }
        return pwd
    }
    
    @IBAction func confirmOnClick(_ sender: Any) {
        let vw = ZCTradeView()
        vw.delegate = self
        vw.show()
    }
    
    func checkInput() ->Bool {
        if serialNumber.characters.count == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "error"))
            return false
        }
        return true
    }
    
    lazy var payeeLabel:UILabel = {
        let label = UILabel()
        label.textColor = self.payeeTextColor
        label.font = self.payeeFont
        return label
    }()
    
    lazy var remarkLabel:UILabel = {
        let label = UILabel()
        label.textColor = self.payeeTextColor
        label.font = self.payeeFont
        return label
    }()

}
