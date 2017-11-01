//
//  CurrencyConversionNumberVC.swift
//  Wallet
//
//  Created by tam on 2017/9/13.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class CurrencyConversionNumberVC: WLMainViewController,ZCTradeViewDelegate {

    @IBOutlet weak var determineButton: UIButton!
    
    //转换币种
    fileprivate let change_coin:String = ""
    
    //当前
    @IBOutlet weak var coin_noTF: UITextField!
    
    //转出  
    @IBOutlet weak var change_coinTF: UITextField!
    
    @IBOutlet weak var amountTF: UITextField!
    
    @IBOutlet weak var transfereeLabel: UILabel!
    
    @IBOutlet weak var transferorLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    //当前币模型
    var coin_assetsListModel = AssetsListModel()
    
    //转出模型
    var change_assetsListModel = AssetsListDetailsModel()
    
    
    let paymentPassword = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "coin_change")
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        
        self.setCloseRoundKeyboard()
        
        coin_noTF.text = coin_assetsListModel.coin_name
        coin_noTF.isEnabled = false
        coin_noTF.backgroundColor = UIColor.white
        
        change_coinTF.text = change_assetsListModel?.coin_name
        change_coinTF.isEnabled = false
        change_coinTF.backgroundColor = UIColor.white
        
        amountTF.keyboardType = .decimalPad
        
        self.createUI()
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        self.closeKeyboard()
        let vw = ZCTradeView()
        vw.delegate = self
        vw.show()
    }
    
    func finish(_ pwd: String) -> String! {
        let userId = UserDefaults.standard.getUserInfo().userId
        let paymentPassword = pwd
        let coin_no = coin_assetsListModel.coin_no?.stringValue
        let change_coin = change_assetsListModel?.coin_no?.stringValue
        let num = amountTF.text!
        let parameters:[String:String] = ["user_id":userId,"paymentPassword":paymentPassword,"coin_no":coin_no!,"change_coin":change_coin!,"num":num]
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIChangeNum, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            if responseData?.code == 100 {
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "change_success"))
                NotificationCenter.default.post(name: Notification.Name(rawValue: "setReloadAssets"), object: nil)
            //设置交易密码
            } else if responseData?.code == 145 {
                //延时1秒执行
                let time: TimeInterval = 0.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                  SVProgressHUD.showInfo(withStatus: responseData?.msg)
                }
                self.perform(#selector(CurrencyConversionNumberVC.pop), with: nil, afterDelay: 1)
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
        }) { (error) in
        }
        return pwd
    }
    
    func createUI(){
        determineButton.clipsToBounds = true
        determineButton.layer.cornerRadius = 20
        
        transfereeLabel.text = LanguageHelper.getString(key: "transferee")
        transferorLabel.text = LanguageHelper.getString(key: "transferor")
        amountLabel.text = LanguageHelper.getString(key: "amount")
        determineButton.setTitle(LanguageHelper.getString(key: "confirm"), for: .normal)
    }
    
    func pop (){
        let vc = SettingPaypsdVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
