//
//  ManageWalletsVC.swift
//  Wallet
//
//  Created by tam on 2017/8/30.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SDWebImage
import ObjectMapper

class ManageWalletsVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource {

    fileprivate let manageWalletsCellIdentifier = "ManageWalletsCellIdentifier"
    fileprivate let footHeight:CGFloat = 35
    fileprivate let cellHeight:CGFloat = 135
    fileprivate let footViewHeight:CGFloat = 50
    fileprivate let titleFont:UIFont = UIFont.systemFont(ofSize: YMAKE(14))
    fileprivate var dataSorce = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "manager_wallet")
        self.getData()
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        self.addFootView()
        self.view.addSubview(tableView)
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
    
    override func backToPrevious() {
        self.navBarBgAlpha = "0"
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSorce.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 15 : footHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: footHeight))
        view.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: manageWalletsCellIdentifier, for: indexPath) as! ManageWalletsCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        let model = self.dataSorce[indexPath.row] as! ManageWalletsData
        cell.titleLabel.text = (model.contacts_name?.removingPercentEncoding)!
        cell.contentLabel.text = model.contacts_id
        cell.iconImageView.sd_setImage(with: NSURL(string:"")! as URL, placeholderImage: UIImage(named: "morentouxiang"))
        return cell
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.footViewHeight - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ManageWalletsCell", bundle: nil),forCellReuseIdentifier: self.manageWalletsCellIdentifier)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH/2, 0,SCREEN_WIDTH/2);
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    func createWallets(){
        let vc = CreateMyWalletVC()
        self.present(vc, animated: true) {
        }
    }
    
    func addFootView()  {
        //底部视图
        let footView = UIView()
        footView.frame = CGRect(x: 0, y: tableView.frame.maxY, width: SCREEN_WIDTH, height: footViewHeight)
        self.view.addSubview(footView)
       
        //右边的视图
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: footView.frame.size.height)
        footView.addSubview(rightView)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: rightView.frame.size.width, height: rightView.frame.size.height)
        rightButton.setTitle(LanguageHelper.getString(key: "create_wallet"), for: .normal)
        rightButton.setImage(UIImage.init(named: "ic_personal_create"), for: .normal)
        rightButton.setTitleColor(R_UIFontMoreDarkColor, for: .normal)
        rightButton.titleLabel?.font = titleFont
        rightButton.addTarget(self, action:#selector(ManageWalletsVC.createWallets), for: .touchUpInside)
        rightView.addSubview(rightButton)
    }
}
