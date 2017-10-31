//
//  VariousLanguagesVC.swift
//  Wallet
//
//  Created by tam on 2017/9/18.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class VariousLanguagesVC: WLMainViewController,UITableViewDataSource,UITableViewDelegate {
    
    enum variouStyle: Int {
        case generalType = 0
        case specialType = 1
    }
    
    enum VariousLanguagesNextStyle: Int {
        case homeType = 0
        case loginType = 1
    }
    
    var myStyle = variouStyle.generalType
    var variousLanguagesNextStyle = VariousLanguagesNextStyle.homeType
    
    fileprivate let cellHeight:CGFloat = 50
    fileprivate let footHeight:CGFloat = 10
    fileprivate let variousLanguagesCellIdentifier = "VariousLanguagesCellIdentifier"
    fileprivate let languageArray:NSArray = ["简体中文","English"]
    fileprivate let monetaryCompany:NSArray = ["CNY","USD"]
    fileprivate var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navBarBgAlpha = "1"
        self.title = myStyle == variouStyle.generalType ? LanguageHelper.getString(key: "language") : LanguageHelper.getString(key: "coin")
        self.addDefaultBackBarButtonLeft()
        self.addDefaultButtonTextRight(LanguageHelper.getString(key: "save"))
        self.indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
        self.view.addSubview(tableView)
        
        if (UserDefaults.standard.object(forKey: R_Languages) != nil) {
            let language = UserDefaults.standard.object(forKey: R_Languages) as! String
            self.indexPath = IndexPath(row: 0, section: language == "en" ? 1 : 0) as IndexPath
        }
    }

    override func rightTextBtn(_ sender: UIBarButtonItem) {
        //设置语言
        if myStyle == variouStyle.generalType {
            //简体中文
            var langeuageString = ""
            if self.indexPath.section == 0 {
                let langeuage = "zh-Hans"
                LanguageHelper.shareInstance.setLanguage(langeuage: langeuage)
                langeuageString = langeuage
            }
            //英语
            if self.indexPath.section == 1 {
                let langeuage = "en"
                LanguageHelper.shareInstance.setLanguage(langeuage: langeuage)
                langeuageString = langeuage
            }
             SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "save_successfully"))
             UserDefaults.standard.set(langeuageString, forKey: R_Languages)
            
            if variousLanguagesNextStyle == .homeType {
                LoginVC.setTabBarController()
            }else{
                LoginVC.switchRootVCToLoginVC()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.myStyle == variouStyle.generalType ? languageArray.count : monetaryCompany.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: footHeight))
        view.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: variousLanguagesCellIdentifier, for: indexPath) as! VariousLanguagesCell
        cell.selectionStyle = .none
        cell.titleLabel.text = self.myStyle == variouStyle.generalType ? languageArray[indexPath.section] as? String : monetaryCompany[indexPath.section] as? String
        cell.checkImageView.isHidden = indexPath.section == self.indexPath.section ? false : true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath == self.indexPath {
           return
         }

         let selectedCell = tableView.cellForRow(at: indexPath) as! VariousLanguagesCell
         selectedCell.checkImageView.isHidden = false
        
         let restoreCell = tableView.cellForRow(at: self.indexPath as IndexPath) as! VariousLanguagesCell
         restoreCell.checkImageView.isHidden = true
        
        self.indexPath  = indexPath
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "VariousLanguagesCell", bundle: nil),forCellReuseIdentifier: self.variousLanguagesCellIdentifier)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        return tableView
    }()

}
