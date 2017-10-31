//
//  SystemSettingsVC.swift
//  Wallet
//
//  Created by tam on 2017/9/1.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class SystemSettingsVC: WLMainViewController,UITableViewDataSource,UITableViewDelegate,ModifyPaymentPasswordDelegate {

    fileprivate let systemSettingsCellIdentifier = "SystemSettingsCellIdentifier"
    fileprivate let cellHeight:CGFloat = 50
    fileprivate let headHeight:CGFloat = 5
    
    fileprivate let iconImageArray:NSArray = ["ic_systemSetting_language","ic_systemSetting_currency","ic_systemSetting_login","ic_systemSetting_passwrod","ic_systemSetting_forget"]

    fileprivate let titleArray:NSMutableArray = [
        LanguageHelper.getString(key: "language")
        ,LanguageHelper.getString(key: "modify_login_passsword")
        ,LanguageHelper.getString(key: "retrieve_Login_Password")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "setting")
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        let password = UserDefaults.standard.getUserInfo().paymentPassword
        if password == "0" {
            titleArray.add(LanguageHelper.getString(key: "set_pay_password"))
        }else{
            titleArray.add(LanguageHelper.getString(key: "find_password"))
        }
        self.view.addSubview(tableView)
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headHeight))
        view.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: systemSettingsCellIdentifier, for: indexPath) as! SystemSettingsCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        cell.titleLabel?.text = titleArray[indexPath.section] as? String
        cell.iconImageView.image = UIImage(named: iconImageArray[indexPath.section] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = VariousLanguagesVC()
            vc.myStyle = VariousLanguagesVC.variouStyle.generalType
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 1 {
            let forgetPwdVC = ForgetPwdViewController()
            forgetPwdVC.viewType = ForgetPwdViewType(rawValue:0)!
            forgetPwdVC.topView.midLabel.text = titleArray[indexPath.section] as? String
            self.present(forgetPwdVC, animated: true, completion: nil)
        }else if indexPath.section == 2{
            let forgetPwdVC = ForgetPwdViewController()
            forgetPwdVC.viewType = .getBackLoginPwd
            forgetPwdVC.topView.midLabel.text = titleArray[indexPath.section] as? String
            self.present(forgetPwdVC, animated: true) {
            }
        }else{
            let password = UserDefaults.standard.getUserInfo().paymentPassword
            if password == "0" {
                let modifyPaymentPasswordVC = ModifyPaymentPasswordVC()
                modifyPaymentPasswordVC.delegate = self
                self.present(modifyPaymentPasswordVC, animated: true, completion: nil)
            }else {
                let forgetPwdVC = ForgetPwdViewController()
                forgetPwdVC.viewType = .getBackPayPwd
                forgetPwdVC.topView.midLabel.text = self.titleArray[indexPath.section] as? String
                self.present(forgetPwdVC, animated: true) {
                    
                }
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SystemSettingsCell", bundle: nil),forCellReuseIdentifier: self.systemSettingsCellIdentifier)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        return tableView
    }()
    
    func modifyPaymentPasswordReloadData() {
        titleArray.replaceObject(at: titleArray.count - 1, with: LanguageHelper.getString(key: "find_password"))
        self.tableView.reloadData()
    }
    
    override func backToPrevious() {
        self.navBarBgAlpha = "0"
        self.navigationController?.popViewController(animated: true)
    }

}
