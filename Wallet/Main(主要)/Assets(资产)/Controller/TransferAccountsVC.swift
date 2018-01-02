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

enum TransferAccountsStatus {
    case transferAccountsEC
    case transferAccountsOther
}
class TransferAccountsVC: WLMainViewController,LBXScanViewControllerDelegate,ContactsDelegate,UITextFieldDelegate,ZCTradeViewDelegate{
    
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var receiveAddressTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var chooseImage: UIImageView!
    @IBOutlet weak var remarkTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var transferAccountsStatus = TransferAccountsStatus.transferAccountsEC
    var totalMoneyString:String = ""
    var receiveAddressString:String = ""
    var coinName = ""
    var coin_no = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = coinName + LanguageHelper.getString(key: "transfer")
        self.receiveAddressTF.text = receiveAddressString;
        self.setTransferAccounts()
        self.addDefaultButtonImageLeft("cuowu")
        if self.coin_no == "0" || self.coin_no == "80" {
           self.addDefaultButtonImageRight("saoyisao")
        }
        if self.coin_no == "0" {
            self.chooseButton.isHidden = false
            self.chooseImage.isHidden = false
        }else{
            self.chooseButton.isHidden = true
            self.chooseImage.isHidden = true
        }
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
        //EC
        if coin_no == "0" || coin_no == "80" {
            if coin_no == "0" {
                if resultStr.contains(R_Theme_QRCode) {
                    let strArray = resultStr.components(separatedBy: "?")
                    if strArray.count != 2 {
                        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "qrCode_error"))
                    }else{
                        self.codeConfiguration(resultStr: resultStr, key: R_Theme_QRCode)
                    }
                }
            }else if coin_no == "80"  {
                if resultStr.contains(R_Theme_QRECZCode) {
                    let strArray = resultStr.components(separatedBy: "?")
                    if strArray.count != 2 {
                        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "qrCode_error"))
                    }else{
                        self.codeConfiguration(resultStr: resultStr, key: R_Theme_QRECZCode)
                    }
                }
            }
        }
    }
    
    func codeConfiguration(resultStr:String,key:String){
        CodeConfiguration.codeProcessing(self, ConstTools.getCodeMessage(resultStr, codeKey: key)! as NSArray, success: { (address,type,data)  in
            if type == "1" {
                let addAContactVC = AddAContactVC()
                addAContactVC.contactsId = address
                self.navigationController?.pushViewController(addAContactVC, animated: true)
            }else if type == "2" {
                self.receiveAddressTF.text = address
            }else if type == "3" {
                let dict =  (WalletOCTools.getDictionaryFromJSONString(data))!
                let responseData = Mapper<MineBusinessCardData>().map(JSONObject: dict)
                let model:MineBusinessCardData = (responseData)!
                let responseCodeData = Mapper<MineBusinessCardCodeDataModel>().map(JSONObject: dict)
                let codeModel:MineBusinessCardCodeDataModel = (responseCodeData)!
                var ids = String(describing: codeModel.id)
                ids = ids.replacingOccurrences(of: "Optional(", with: "")
                ids = ids.replacingOccurrences(of: ")", with: "")
                model.id = ids
                let addBusiessCardVC = AddBusiessCardVC()
                addBusiessCardVC.mineBusinessCardData = model
                addBusiessCardVC.addBusinessCardType = .addBusiessFriendCard
                addBusiessCardVC.busiessCardType = .addBusiessFriendCard
                self.navigationController?.pushViewController(addBusiessCardVC, animated: true)
            }
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 15
        let currentString: NSString = remarkTF.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
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
        if transferAccountsStatus == .transferAccountsEC {
            self.payMoney()
        }else{
            self.getPayPassword()
        }
    }
    @IBAction func pushToContacts(_ sender: UIButton) {
        let vc = ContactsVC()
        vc.delegate = self
        vc.isAddContacts = true
        self.pushNextViewController(vc, true)
    }
    
    func getPayPassword(){
        let vw = ZCTradeView()
        vw.delegate = self
        vw.show()
    }
    
    func finish(_ pwd: String!) -> String! {
        self.payOtherPrice(password: pwd)
        return pwd
    }
    
    func payOtherPrice(password:String){
        let outId = UserDefaults.standard.getUserInfo().userId
        let inId = self.receiveAddressTF.text!
        let money = self.amountTF.text!
        let pay_password = password
        let parameters = ["inId":inId,"outId":outId,"coin_no":coin_no,"amount":money,"pay_password":pay_password]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"), maskType: .black)
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIBillTranSfer, parameters: parameters, showIndicator: false, success: { (json) in
            SVProgressHUD.dismiss()
            let responseData = Mapper<PayMoneyModel>().map(JSONObject: json)
            if responseData?.code == "100" {
                SVProgressHUD.showSuccess(withStatus: "转账成功")
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }

    //获取流水订单号
    func payMoney(){
        let userId = UserDefaults.standard.getUserInfo().userId
        let phone_shou = self.receiveAddressTF.text!
        let money = self.amountTF.text!
//        let remark:String = (self.remarkTF?.text!)!
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
                    vc.remark = (self.remarkTF?.text!)!
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
