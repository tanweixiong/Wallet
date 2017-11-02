//
//  TransactionRecordVC.swift
//  Wallet
//
//  Created by tam on 2017/8/31.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class TransactionRecordVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource {

    fileprivate let transactionRecordCellIdentifier = "TransactionRecordCellIdentifier"
    fileprivate let cellHeight:CGFloat = 75
    fileprivate let footHeight:CGFloat = 20
    fileprivate var dataScore = NSMutableArray()
    fileprivate var addDataScore = NSMutableArray()
    fileprivate var page:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "trade")
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        self.view.addSubview(tableView)
        self.getData()
    }
    
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id,"page":"\(page)"]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIChangerecordList, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<TransactionRecordModel>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == "100" {
                    self.page = self.page + 1
                    let array = NSMutableArray()
                    array.addObjects(from: (responseData?.data)!)
                    
                    array.addObjects(from: self.dataScore as! [Any])
                    self.dataScore = array
                    self.tableView.reloadData()
                }
            }
            self.tableView.mj_header.endRefreshing()
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.dataScore.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: transactionRecordCellIdentifier, for: indexPath) as! TransactionRecordCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        
        let model = dataScore[indexPath.section] as! TransactionRecordData
        cell.titleLabel.text = model.coin_name
        cell.transactionLabel.text = model.change_num?.stringValue
        cell.timeLabel.text = model.date
        cell.coinIcon.sd_setImage(with: NSURL(string: model.coinIcon!)! as URL, placeholderImage: UIImage.init(named: "jiazaimoren"))
        return cell
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 20))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TransactionRecordCell", bundle: nil),forCellReuseIdentifier: self.transactionRecordCellIdentifier)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
          self.getData()
        })
        return tableView
    }()
    
    override func backToPrevious() {
        self.navBarBgAlpha = "0"
        self.navigationController?.popViewController(animated: true)
    }
}
