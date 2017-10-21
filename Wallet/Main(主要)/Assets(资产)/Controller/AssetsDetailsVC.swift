//
//  AssetsDetailsVC.swift
//  Wallet
//
//  Created by tam on 2017/9/11.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage
import SVProgressHUD

protocol AssetsDetailsDelegate:NSObjectProtocol{
    func setReloadAssets()
}

class AssetsDetailsVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate let assetsDetailsCellIdentifier = "AssetsDetailsCellIdentifier"
    fileprivate let cellHeight:CGFloat = 100
    fileprivate let dataScore = NSMutableArray()
    fileprivate let headHeight: CGFloat = 10
    var delegate:AssetsDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "add_assets")
        self.navBarBgAlpha = "1"
        self.view.addSubview(tableView)
        self.getData()
        self.addDefaultBackBarButtonLeft()
    }
    
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIWalletList, parameters: parameters, showIndicator: true, success: { (json) in
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
    
    func chooseCoin(_ state:String,_ coin_no:String) {
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id,"coin_no":coin_no,"state":state]
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIMyWalletState, parameters: parameters, showIndicator: true, success: { (json) in
            let data:[String:AnyObject] = json as! [String : AnyObject]
            let code = data["code"]?.int64Value
            if code == 100 {
                //回调首页
                self.delegate?.setReloadAssets()
            }else if code == 100 {
                LoginVC.setTokenInvalidation()
            }else{
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "some_error"))
            }
        }) { (error) in
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: assetsDetailsCellIdentifier, for: indexPath) as! AssetsDetailsCell
        cell.selectionStyle = .none
        cell.backgroundColor = R_UIThemeColor
        let model = dataScore[indexPath.section] as! AssetsListDetailsModel
        cell.contentLabel.text = model.coin_name
        cell.iconImageView.sd_setImage(with: NSURL(string: "")! as URL, placeholderImage: UIImage.init(named: "jiazaimoren"))
        cell.coinSwitch.isOn = model.state == 0 ? true : false
        cell.coinSwitch.tag = indexPath.section
        cell.coinSwitch.isHidden = indexPath.section == 0 ? true : false
        cell.iconImageView.sd_setImage(with: NSURL(string: model.coinIcon!)! as URL, placeholderImage: UIImage.init(named: "jiazaimoren"))
        cell.assetsDetailsBlock = { (sender:UISwitch) in
            let model = self.dataScore[sender.tag] as! AssetsListDetailsModel
            let state = sender.isOn == true ? "0" : "1"
            let coin_no = model.coin_no?.stringValue
            self.chooseCoin(state, coin_no!)
        }
        return cell
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AssetsDetailsCell", bundle: nil),forCellReuseIdentifier: self.assetsDetailsCellIdentifier)
        tableView.backgroundColor = R_UIThemeColor
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.separatorStyle = .none
        return tableView
    }()
}
