//
//  IndustryVC.swift
//  Wallet
//
//  Created by tam on 2017/8/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD
import MJRefresh

class IndustryVC: WLMainViewController,UITableViewDataSource,UITableViewDelegate,AddMarketDelegate,EditMarketDelegate{
    
    fileprivate let industryHeadCellIdentifier = "industryHeadCellIdentifier"
    fileprivate let industryViewCellIdentifier = "industryViewCellIdentifier"
    fileprivate let cellHeight :CGFloat = 100
    fileprivate let footHeight :CGFloat = 10
    fileprivate let headViewHeight :CGFloat = 42
    fileprivate let headFont :UIFont = UIFont.systemFont(ofSize: 14)
    fileprivate var dataScore = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "markets")
        self.addDefaultButtonImageRight("anymore")
        self.getMarkertData()
        self.view.addSubview(headView)
        self.view.addSubview(tableView)
        UIApplication.shared.keyWindow?.addSubview(marketModificationView)
    }
    
    //首页数据
    func getMarkertData(){
        if Tools.getPlaceOnFile(R_UserDefaults_Market_Key) is NSNull {
            self.getData()
        }else{
            let json = Tools.getPlaceOnFile(R_UserDefaults_Market_Key) as!NSArray
            let data = ["data":json]
            let responseData = Mapper<IndustryListModel>().map(JSONObject: data)
            if responseData?.data?.count != 0 {
                self.dataScore = responseData!.data as! NSMutableArray
                self.tableView.reloadData()
            }
        }
    }
    
    //获取行情网络数据并保存在本地
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIMyMarket, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<IndustryListModel>().map(JSONObject: json)
            if responseData?.code == 100 {
                let object:NSDictionary = json as! NSDictionary
                let data = object.object(forKey: "data") as! NSArray
                Tools.savePlaceOnFile(R_UserDefaults_Market_Key, data)
                self.getMarkertData()
            }else if responseData?.code == 200 {
                LoginVC.setTokenInvalidation()
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
        }) { (error) in

        }
    }
    
    func addMarketReload(){
        self.getMarkertData()
    }
    
    func editMarketReload() {
        self.getMarkertData()
    }
    
    override func rightImageBtn(_ sender: UIBarButtonItem) {
        marketModificationView.isHidden = marketModificationView.isHidden ? false : true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataScore.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: footHeight))
        view.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xF6FAFB)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: industryViewCellIdentifier, for: indexPath) as! IndustryViewCell
        cell.selectionStyle = .none
        let model = self.dataScore[indexPath.section] as! IndustryListData
        cell.cnyLabel.text = "¥" + " " + (model.cny?.stringValue)!
        cell.coin_nameLabel.text = model.coin_name
        cell.usdLabel.text = "$" + " " + (model.usd?.stringValue)!
        cell.limitLabel.text = (model.limit?.stringValue)! + "" + "%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = IndustryDetailsVC()
        let model = self.dataScore[indexPath.section] as! IndustryListData
        vc.coin_no = (model.coin_no?.stringValue)!
        self.pushNextViewController(vc, true)
    }
    
    lazy var marketModificationView: MarketModificationView = {
        let view = Bundle.main.loadNibNamed("MarketModificationView", owner: nil, options: nil)?.last as! MarketModificationView
        view.isHidden = true
        view.frame = (UIApplication.shared.keyWindow?.bounds)!
        view.backgroundColor = UIColor.R_UIRGBColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.marketModificationBlock = { (sender) in
            if sender.tag == 1 {
                let vc = addMarketVC()
                vc.delegate = self
                self.pushNextViewController(vc, true)
            }else if sender.tag == 2{
               let vc = editMarketVC()
                vc.delegate = self
               self.pushNextViewController(vc, true)
            }
        }
        return view
    }()
    
    lazy var headView: UIView = {
        let headView = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.headViewHeight)
        headView.backgroundColor = R_UIThemeColor
        headView.addSubview(self.nameLabel)
        headView.addSubview(self.riseLabel)
        headView.addSubview(self.newLabel)
        headView.layer.addSublayer(self.layers)
        return headView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 0, width: SCREEN_WIDTH/2, height: self.headViewHeight)
        label.textColor = UIColor.white
        label.text = LanguageHelper.getString(key: "asset_name")
        label.font = self.headFont
        return label
    }()

    lazy var riseLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: SCREEN_WIDTH - SCREEN_WIDTH/3 - 20, y: 0, width: SCREEN_WIDTH/3, height: self.headViewHeight)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.text = LanguageHelper.getString(key: "up_low")
        label.font = self.headFont
        return label
    }()
    
    lazy var newLabel: UILabel = {
        let label = UILabel()
        let lastestPrice = LanguageHelper.getString(key: "lastest_price")
        let size:CGSize = label.getStringSize(text: lastestPrice, size: CGSize(width: SCREEN_WIDTH, height: self.headViewHeight), font:14)
        label.frame = CGRect(x: SCREEN_WIDTH/2 - size.width/2, y: 0, width: size.width, height: self.headViewHeight)
        label.textColor = UIColor.white
        label.text = lastestPrice
        label.font = self.headFont
        label.textAlignment = .center
        return label
    }()
    
    lazy var layers: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH , height: 0.5)
        layer.backgroundColor  =  UIColor.R_UIColorFromRGB(color: 0xdddddd).cgColor
        return layer
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: self.headViewHeight , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 44 - self.headViewHeight + 5))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "IndustryHeadCell", bundle: nil),forCellReuseIdentifier: self.industryHeadCellIdentifier)
        tableView.register(UINib(nibName: "IndustryViewCell", bundle: nil),forCellReuseIdentifier: self.industryViewCellIdentifier)
        tableView.backgroundColor = R_UIThemeBackgroundColor
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
//        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//            self.getData()
//        })
        return tableView
    }()

}
