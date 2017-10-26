//
//  FindVC.swift
//  Wallet
//
//  Created by tam on 2017/8/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD

class FindVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate let findCellIdentifier = "findCellIdentifier"
    fileprivate let cellHeight:CGFloat = 80
    fileprivate let dataScore = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  LanguageHelper.getString(key: "information")
        self.view.addSubview(tableView)
        self.getData()
    }
    
    //资讯
    func getData(){
        let url = ConstAPI.kAPINews
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id]
        NetWorkTool.request(requestType: .get, URLString: url, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<FindModel>().map(JSONObject: json)
            if responseData?.code == 100 {
                if responseData?.data?.count != 0{
                    self.tableView.backgroundColor = R_UIThemeColor
                    self.dataScore.addObjects(from: (responseData?.data)!)
                    self.tableView.reloadData()
                }
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
        }) { (error) in
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func  tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        view.backgroundColor = R_UIThemeColor
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: findCellIdentifier, for: indexPath) as! FindCell
        cell.selectionStyle = .none
        cell.backgroundColor = R_UIThemeColor
        let model = self.dataScore[indexPath.section] as! FindDetailModel
        cell.titleLabel.text = model.news_title
        cell.contentLabel.text = model.news_text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataScore[indexPath.section] as! FindDetailModel
        let findDetailVC = FindDetailVC()
        findDetailVC.findDetailModel = model
        self.navigationController?.pushViewController(findDetailVC, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 45 - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FindCell", bundle: nil),forCellReuseIdentifier: self.findCellIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        return tableView
    }()

}
