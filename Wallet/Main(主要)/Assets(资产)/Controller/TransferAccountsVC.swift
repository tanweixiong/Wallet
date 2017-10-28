//
//  TransferAccountsVC.swift
//  Wallet
//
//  Created by tam on 2017/9/14.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class TransferAccountsVC: WLMainViewController,LBXScanViewControllerDelegate,ContactsDelegate{
    
    @IBOutlet weak var receiveAddressTF: UITextField!
    
    @IBOutlet weak var amountTF: UITextField!

    @IBOutlet weak var remarkTF: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    var totalMoneyString:String = ""
    var receiveAddressString:String = ""
    var coinName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = coinName + LanguageHelper.getString(key: "transfer")
        self.receiveAddressTF.text = receiveAddressString;
        self.setTransferAccounts()
        self.addDefaultButtonImageLeft("cuowu")
        self.addDefaultButtonImageRight("saoyisao")
    }
    
    override func rightImageBtn(_ sender: UIBarButtonItem) {
        let vc = LBXScanViewController();
        vc.title = LanguageHelper.getString(key: "scan")
        vc.scanStyle = vc.setCustomLBScan()
        vc.scanResultDelegate = self
        self.pushNextViewController(vc, true)
    }
    
    override func leftImageBtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        let resultStr = scanResult.strScanned!
        self.setProcessingString(resultStr: resultStr)
    }
    
    func setTransferAccounts(){
        receiveAddressTF.placeholder = LanguageHelper.getString(key: "payee_address")
        amountTF.placeholder = LanguageHelper.getString(key: "extras")
        remarkTF.placeholder = LanguageHelper.getString(key: "reamrk_limit")
        nextButton.setTitle(LanguageHelper.getString(key: "the_next"), for: .normal)
    }
    
    //扫描正确后操作
    func setProcessingString(resultStr:String) {
        if resultStr.contains(R_Theme_QRCode) {
            let strArray = resultStr.components(separatedBy: "?")
            if strArray.count != 2 {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "qrCode_error"))
            }else{
                CodeConfiguration.codeProcessing(self, ConstTools.getCodeMessage(resultStr, codeKey: R_Theme_QRCode)! as NSArray, success: { (address,type) in
                    if type == "1" {
                        let addAContactVC = AddAContactVC()
                        addAContactVC.contactsId = address
                        self.navigationController?.pushViewController(addAContactVC, animated: true)
                    }else if type == "2" {
                        self.receiveAddressTF.text = address
                    }
                })
            }
        }
    }
   
    @IBAction func nextOnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        if receiveAddressTF.text?.characters.count == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "write_address"))
            return
        }
        
        if amountTF.text?.characters.count == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "write_amount"))
            return
        }
        
        self.payMoney()
    }
    @IBAction func pushToContacts(_ sender: UIButton) {
        let vc = ContactsVC()
        vc.delegate = self
        vc.isAddContacts = true
        self.pushNextViewController(vc, true)
    }

    //获取流水订单号
    func payMoney(){
        let userId = UserDefaults.standard.getUserInfo().userId
        let phone_shou = self.receiveAddressTF.text!
        let money = self.amountTF.text!
        let remark:String = (self.remarkTF?.text!)!
        let parameter:[String:Any] = ["userId":userId,"phone_shou":phone_shou,"money":money,"remark":"11","flag":"2"]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"), maskType: .black)
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPITransOrder, parameters: parameter, showIndicator: true, success: { (json) in
            let responseData = Mapper<PayMoneyModel>().map(JSONObject: json)
            if let code = responseData?.code {
                SVProgressHUD.dismiss()
                if code == "100" {
                    let score:[String:Any] = json as! [String : Any]
                    let data:[String:Any]  = score["data"] as! [String : Any]
                    let vc = PaymentConfirmationVC()
                    vc.payee = (responseData?.data?.phone_shou)!
                    vc.dhs = String(describing: data["money"]!)
                    vc.totalAmount = String(describing: data["sumMoney"]!)
                    vc.serviceCharge = String(describing: data["sxf"]!)
                    vc.serialNumber = String(describing: data["SerialNumber"]!)
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: responseData?.msg)
                }
            }
        }
        ) { (error) in
            
        }
    }
    
    func contactsCallBackUserID(_ userID: String) {
        receiveAddressTF.text = userID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
