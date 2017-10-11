//
//  CurrencyConversionVC.swift
//  Wallet
//
//  Created by tam on 2017/9/13.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class CurrencyConversionVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate let currencyConversionCellIdentifier = "CurrencyConversionCellIdentifier"
    fileprivate let cellHeight:CGFloat = 100
    fileprivate let dataScore = NSMutableArray()
    fileprivate let headHeight: CGFloat = 10

    //当前币模型
    var assetsListModel = AssetsListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "coin_change")
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        self.view.addSubview(tableView)
        self.getData()
    }
    
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id]
        NetWorkTool.request(.get, URLString: ConstAPI.kAPICoinlist, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<AssetsDetailsModel>().map(JSONObject: json)
            if responseData?.code == 100 {
                self.dataScore.addObjects(from: (responseData?.data)!)
                self.tableView.reloadData()
            }else if responseData?.code == 200 {
                LoginVC.setTokenInvalidation()
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
        }) { (error) in
            
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headHeight)
        view.backgroundColor = R_UIThemeColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currencyConversionCellIdentifier, for: indexPath) as! CurrencyConversionCell
        cell.selectionStyle = .none
        cell.backgroundColor = R_UIThemeColor
        let model = dataScore[indexPath.section] as! AssetsListDetailsModel
        cell.coin_name.text = model.coin_name
        cell.iconImageView.sd_setImage(with: NSURL(string: model.icon!)! as URL, placeholderImage: UIImage.init(named: "jiazaimoren"))
        cell.conversionButton.tag = indexPath.section
        cell.currencyConversionBlock = {(sender:UIButton) in
            let vc = CurrencyConversionNumberVC()
            vc.coin_assetsListModel = self.assetsListModel
            vc.change_assetsListModel = self.dataScore[sender.tag] as? AssetsListDetailsModel
            self.pushNextViewController(vc, true)
        }
        return cell
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CurrencyConversionCell", bundle: nil),forCellReuseIdentifier: self.currencyConversionCellIdentifier)
        tableView.backgroundColor = R_UIThemeColor
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.separatorStyle = .none
        return tableView
    }()

}
