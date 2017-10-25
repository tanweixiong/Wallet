//
//  FriendBusinessCardVC.swift
//  Wallet
//
//  Created by tam on 2017/10/24.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import MJRefresh

class FriendBusinessCardVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource {
    var delegate:ContactsDelegate?
    fileprivate let friendBusinessCellIdentifier = "FriendBusinessCellIdentifier"
    fileprivate let cellHeight:CGFloat = 75
    fileprivate let footHeight:CGFloat = 20
    fileprivate var dataSorce = NSMutableArray()
    fileprivate var page:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "friends_business_card")
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        self.view.addSubview(tableView)
        self.getData()
    }
    
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id,"page":"\(page)"]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIFriendTheCardList, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<MineBusinessCardModel>().map(JSONObject: json)
            let data:NSDictionary = json as! NSDictionary
            let code:String = data["code"] as! String
            if code == "100" {
                self.page = self.page + 1
                let array = NSMutableArray()
                array.addObjects(from: (responseData?.data)!)
                array.addObjects(from: self.dataSorce as! [Any])
                self.dataSorce = array
                self.tableView.reloadData()
            }else{
                WLInfo(responseData!.msg)
            }
            self.tableView.mj_header.endRefreshing()
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func deleteFriendCard(_ model:MineBusinessCardData,_ indexPath:IndexPath){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let id = (model.id)!
        let parameters:[String:Any] = ["card_id":id,"user_id":user_id]
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIBusinessRelevanceDelete, parameters: parameters, showIndicator: true, success: { (json) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: friendBusinessCellIdentifier, for: indexPath) as! ContactsViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        let model = dataSorce[indexPath.section] as! MineBusinessCardData
        cell.titleLabel?.text = (model.name?.removingPercentEncoding)!
        cell.contentLabel.isHidden = true
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let businessCardVC = BusinessCardVC()
//        businessCardVC.mineBusinessCardData = (self.dataSorce[indexPath.row] as! MineBusinessCardData)
//        businessCardVC.businessDetailType = .businessCardDetailFriend
//        self.navigationController?.pushViewController(businessCardVC, animated: true)
//    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContactsViewCell", bundle: nil),forCellReuseIdentifier: self.friendBusinessCellIdentifier)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getData()
        })
        return tableView
    }()
    
    //处理选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //返回编辑类型，滑动删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //在这里修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "点击删除"
    }
    
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let model = self.dataSorce[indexPath.section] as! MineBusinessCardData
            self.deleteFriendCard(model, indexPath)
        }
    }
    
    override func backToPrevious() {
        self.navBarBgAlpha = "0"
        self.navigationController?.popViewController(animated: true)
    }

}
