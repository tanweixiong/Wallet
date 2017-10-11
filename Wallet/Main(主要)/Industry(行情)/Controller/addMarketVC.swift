//
//  addMarketVC.swift
//  Wallet
//
//  Created by tam on 2017/9/20.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

protocol AddMarketDelegate:NSObjectProtocol{
    func addMarketReload()
}

class addMarketVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource {

    fileprivate let addMarketCellIdentifier = "AddMarketCellIdentifier"
    fileprivate let cellHeight:CGFloat = 100
    fileprivate let dataScore = NSMutableArray()
    fileprivate let headHeight: CGFloat = 10
    var delegate:AddMarketDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "add_market"
        self.navBarBgAlpha = "1"
        self.view.addSubview(tableView)
        self.getData()
        self.addDefaultBackBarButtonLeft()
    }
    
    //详情数据
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id]
        NetWorkTool.request(.get, URLString: ConstAPI.kAPIMarketList, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<addMarketModel>().map(JSONObject: json)
            if responseData?.code == 100 {
                self.dataScore.addObjects(from: (responseData?.data)!)
                self.tableView.reloadData()
            }else if responseData?.code == 200 {
                LoginVC.setTokenInvalidation()
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
        }) { (error) in}
    }
    
    func chooseCoin(_ state:String,_ coin_no:String,_ index:Int) {
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id,"coin_no":coin_no,"market_state":state]
        NetWorkTool.request(.post, URLString: ConstAPI.KAPIMyMarketState, parameters: parameters, showIndicator: true, success: { (json) in
            let data:[String:AnyObject] = json as! [String : AnyObject]
            let code = data["code"]?.int64Value
            if code == 100 {
                //关闭
                let data:Array = Tools.getPlaceOnFile(R_UserDefaults_Market_Key) as! NSArray as Array
                let arrays = NSMutableArray()
                arrays.addObjects(from: data)
      
                let newState:Int = Int(state)!
                if newState == 0 {
                    for item in 0...arrays.count - 1 {
                        let data:NSDictionary = arrays[item] as! NSDictionary
                        let coin = data["coin_no"] as! NSNumber
                        let coin_number = coin.stringValue
                        if coin_no.isEqual(coin_number){
                            arrays.removeObject(at: item)
                            Tools.savePlaceOnFile(R_UserDefaults_Market_Key, arrays)
                            break
                        }
                    }
                    self.delegate?.addMarketReload()
                }else{
                    self.uploadMarket(coin_no, index)
                }
    
            }else if code == 100 {
                LoginVC.setTokenInvalidation()
            }else{
                SVProgressHUD.showInfo(withStatus: "修改不成功请稍后再试")
            }
        }) { (error) in
        }
    }
    
    func uploadMarket(_ coin_no:String,_ index:Int){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id]
        NetWorkTool.request(.get, URLString: ConstAPI.kAPIMyMarket, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<IndustryListModel>().map(JSONObject: json)
            if responseData?.code == 100 {
                let object:NSDictionary = json as! NSDictionary
                let data = object.object(forKey: "data") as! NSArray
                for item in 0...data.count - 1{
                    let data:NSDictionary = data[item] as! NSDictionary
                    let coin = data["coin_no"] as! NSNumber
                    let coin_number = coin.stringValue
                    if coin_no.isEqual(coin_number){
                        
                        let fileData:Array = Tools.getPlaceOnFile(R_UserDefaults_Market_Key) as! NSArray as Array
                        let arrays = NSMutableArray()
                        arrays.addObjects(from: fileData)
                        arrays.insert(data, at: index)
                        Tools.savePlaceOnFile(R_UserDefaults_Market_Key, arrays)
                        
                        self.delegate?.addMarketReload()
                    }
                }

            }else if responseData?.code == 200 {
                LoginVC.setTokenInvalidation()
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: addMarketCellIdentifier, for: indexPath) as! addMarketCell
        cell.selectionStyle = .none
        cell.backgroundColor = R_UIThemeColor
        let model = dataScore[indexPath.section] as! addMarketData
        cell.titleLabel.text = model.coin_name
        cell.coinSwitch.isOn = model.market_state == 0 ? false : true
        cell.coinSwitch.tag = indexPath.section
        cell.coinSwitch.isHidden = indexPath.section == 0 ? true : false
        cell.addMarketBlock = { (sender:UISwitch) in
            let model = self.dataScore[sender.tag] as! addMarketData
            let state = sender.isOn == true ? "1" : "0"
            let coin_no = model.coin_no?.stringValue
            self.chooseCoin(state, coin_no!,sender.tag)
        }
        return cell
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "addMarketCell", bundle: nil),forCellReuseIdentifier: self.addMarketCellIdentifier)
        tableView.backgroundColor = R_UIThemeColor
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.separatorStyle = .none
        return tableView
    }()

}
