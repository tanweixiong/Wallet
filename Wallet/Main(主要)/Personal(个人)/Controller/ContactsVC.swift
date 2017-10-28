//
//  ContactsVC.swift
//  Wallet
//
//  Created by tam on 2017/9/1.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

protocol ContactsDelegate:NSObjectProtocol{
    func contactsCallBackUserID(_ userID:String)
}

class ContactsVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource,AddContactDelegate {
    var delegate:ContactsDelegate?
    fileprivate let contactsViewCellIdentifier = "ContactsViewCellIdentifie"
    fileprivate let cellHeight:CGFloat = 75
    fileprivate let footHeight:CGFloat = 20
    fileprivate let dataSorce = NSMutableArray()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
