//
//  AddAContactVC.swift
//  Wallet
//
//  Created by tam on 2017/9/19.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import ObjectMapper
import SnapKit

protocol AddContactDelegate:NSObjectProtocol{
    func setReloadContact()
}

class AddAContactVC: WLMainViewController,LBXScanViewControllerDelegate {

    var delegate:AddContactDelegate?
    
    fileprivate let hornImageSize:CGFloat = 60
    
    @IBOutlet weak var contacts_nameTF: UITextField!
    
    @IBOutlet weak var contacts_idTF: UITextField!
    
    @IBOutlet weak var remarksTF: UITextField!
    
    @IBOutlet weak var backgroundVw: UIView!
    
    var contactsId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "add_contact")
        self.view.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        self.addDefaultButtonTextRight(LanguageHelper.getString(key: "save"))
        self.addDefaultBackBarButtonLeft()
        view.addSubview(hornImageView)
        let photo = UserDefaults.standard.getUserInfo().photo
        hornImageView.sd_setImage(with: NSURL(string:photo) as URL? , placeholderImage: UIImage(named: "morentouxiang"))
        hornImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundVw.snp.centerX)
            make.top.equalTo(backgroundVw.snp.top).offset(-hornImageSize/2)
            make.width.equalTo(hornImageSize)
            make.height.equalTo(hornImageSize)
        }
        self.setLanguage()
        self.contacts_idTF.text = contactsId
    }
    
    @IBAction func scanOnClick(_ sender: UIButton) {
        let vc = LBXScanViewController();
        vc.title = LanguageHelper.getString(key: "scan")
        vc.scanStyle = vc.setCustomLBScan()
        vc.scanResultDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func rightTextBtn(_ sender: UIBarButtonItem) {
        if checkOut(){
            let user_id = UserDefaults.standard.getUserInfo().userId
            let contacts_id = contacts_idTF.text!
            let contacts_name = contacts_nameTF.text!
            let remarks = remarksTF.text!
            let parameters:[String:String] = ["user_id":user_id,"contacts_id":contacts_id,"contacts_name":contacts_name,"remarks":remarks]
            NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIMyAddContacts, parameters: parameters, showIndicator: true, success: { (json) in
                let responseData = Mapper<ResponseData>().map(JSONObject: json)
                if let code = responseData?.code {
                    if code == 100 {
                        WLSuccess(LanguageHelper.getString(key: "Added_Successfully"))
                        self.delegate?.setReloadContact()
                    } else {
                        WLInfo(responseData?.msg)
                    }
                }
            }) { (error) in
            }
        }
    }

    //扫描正确后操作
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        let resultStr = scanResult.strScanned!
        if resultStr.contains(R_Theme_QRCode){
            let strArray = resultStr.components(separatedBy: ":")
            if strArray.count != 2 {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "qrCode_error"))
                return
            } else {
                let userid = strArray[1]
                contacts_idTF.text = userid
            }
        } else {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "qrCode_error"))
            return
        }
    }
    
    func checkOut() -> Bool{
        if contacts_idTF.text?.characters.count == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "please_write_contacts_address"))
            return false
        }
        
        if contacts_nameTF.text?.characters.count == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "please_write_contacts_name"))
            return false
        }

        return true
    }
    
    func setLanguage() {
        contacts_nameTF.placeholder = LanguageHelper.getString(key: "please_write_contacts_name")
        contacts_idTF.placeholder = LanguageHelper.getString(key: "address")
        remarksTF.placeholder = LanguageHelper.getString(key: "remark")
    }
    
    lazy var hornImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "morentouxiang")
        imageView.layer.cornerRadius = self.hornImageSize/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
