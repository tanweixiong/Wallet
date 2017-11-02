//
//  ContactsVC.swift
//  Wallet
//
//  Created by tam on 2017/9/1.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD

protocol ContactsDelegate:NSObjectProtocol{
    func contactsCallBackUserID(_ userID:String)
}

class ContactsVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource,AddContactDelegate,UIAlertViewDelegate {
    var delegate:ContactsDelegate?
    fileprivate let contactsViewCellIdentifier = "ContactsViewCellIdentifie"
    fileprivate let cellHeight:CGFloat = 75
    fileprivate let footHeight:CGFloat = 20
    fileprivate let dataSorce = NSMutableArray()
    fileprivate var detailModel = ManageWalletsData()
    fileprivate var delteIndexPath = IndexPath()
    var isAddContacts:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "contacts")
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        self.addDefaultButtonImageRight("tianjia")
        self.view.addSubview(tableView)

        self.getData()
    }
    
    func getData(){
        let userId = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":userId]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIMycontacts, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<ManageWalletsModel>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == 100 {
                    self.dataSorce.removeAllObjects()
                    self.dataSorce.addObjects(from: (responseData?.data)!)
                    self.tableView.reloadData()
                }
            }
        }) { (error) in
        }
    }
    
    func deleteContacts(_ model:ManageWalletsData,_ indexPath:IndexPath){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let contacts_id = model.contacts_id!
        let parameters:[String:Any] = ["contacts_id":contacts_id,"user_id":user_id]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"), maskType: .black)
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIMyDeleteContacts, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == 100 {
                    self.dataSorce.removeObject(at: indexPath.section)
                    self.tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: UITableViewRowAnimation.fade)
                    WLInfo(LanguageHelper.getString(key: "delete_sucess"))
                }else{
                    WLInfo(responseData?.msg)
                }
            }
        }) { (error) in
        }
    }
    
    override func rightImageBtn(_ sender: UIBarButtonItem) {
        let vc = AddAContactVC()
        vc.delegate = self
        self.pushNextViewController(vc, true)
    }
    
    func setReloadContact(){
        self.getData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  dataSorce.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: contactsViewCellIdentifier, for: indexPath) as! ContactsViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        let model = dataSorce[indexPath.section] as! ManageWalletsData
        cell.titleLabel?.text = model.contacts_name?.removingPercentEncoding
        cell.contentLabel.text = model.contacts_id
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAddContacts {
            let model = dataSorce[indexPath.section] as! ManageWalletsData
            self.delegate?.contactsCallBackUserID(model.contacts_id!)
            self.navigationController?.popViewController(animated: true)
        }else{
             self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    //返回编辑类型，滑动删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if isAddContacts {
            return UITableViewCellEditingStyle.none
        }
        return UITableViewCellEditingStyle.delete
    }
    
    //在这里修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return LanguageHelper.getString(key: "delete")
    }
    
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let model = self.dataSorce[indexPath.section] as! ManageWalletsData
            self.detailModel = model
            self.delteIndexPath = indexPath
            self.alert(model, indexPath)
        }
    }
    
    //警告框
    func alert(_ model:ManageWalletsData,_ indexPath:IndexPath){
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title:LanguageHelper.getString(key: "prompt"),message:LanguageHelper.getString(key: "You_sure_you_want_to_delete_it"),preferredStyle:UIAlertControllerStyle.alert)
            let cancelAction=UIAlertAction(title: LanguageHelper.getString(key: "version_cancel"), style: UIAlertActionStyle.default) { (alert) in
                
            }
            let okAction=UIAlertAction(title: LanguageHelper.getString(key: "confirm"), style: UIAlertActionStyle.default) { (alert) in
                self.deleteContacts(model, indexPath)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            //8.0以下
        }else{
            let alertView = UIAlertView()
            alertView.title = LanguageHelper.getString(key: "prompt")
            alertView.message = LanguageHelper.getString(key: "You_sure_you_want_to_delete_it")
            alertView.addButton(withTitle: LanguageHelper.getString(key: "version_cancel"))
            alertView.addButton(withTitle: LanguageHelper.getString(key: "confirm"))
            alertView.cancelButtonIndex=0
            alertView.delegate=self;
            alertView.show()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if(buttonIndex==alertView.cancelButtonIndex){
        }else{
            self.deleteContacts(self.detailModel!, self.delteIndexPath)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContactsViewCell", bundle: nil),forCellReuseIdentifier: self.contactsViewCellIdentifier)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        return tableView
    }()

    override func backToPrevious() {
        self.navBarBgAlpha = "0"
        self.navigationController?.popViewController(animated: true)
    }
}
