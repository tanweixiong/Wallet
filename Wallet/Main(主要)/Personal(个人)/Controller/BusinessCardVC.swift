//
//  BusinessCardVC.swift
//  Wallet
//
//  Created by tam on 2017/10/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

public protocol BusinessCardDetailDelegate {
    func businessCardDetailReloadData()
}

enum BusinessDetailType {
    case businessCardDetailMine
    case businessCardDetailFriend
}

class BusinessCardVC:WLMainViewController, UITableViewDelegate,UITableViewDataSource {
    fileprivate let businessCardCellIdentifier = "AddAddressCellIdentifier"
    fileprivate let titleArray:NSArray = ["职位","姓名","邮箱","微信","手机","其他"]
    fileprivate var contentArray:NSArray = NSArray()
    var mineBusinessCardData = MineBusinessCardData()
    var delegate:BusinessCardDetailDelegate?
    struct BusinessCardUX{
        static let sectionHeight:CGFloat = 16
        static let rowHeight:CGFloat = 54
        static let headHeight:CGFloat = 169
    }
    var businessDetailType = BusinessDetailType.businessCardDetailMine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCloseRoundKeyboard()
        self.view.backgroundColor = R_UIThemeBackgroundColor
        self.title = LanguageHelper.getString(key: "card")
        self.addDefaultBackBarButtonLeft()
        self.getData()
        view.addSubview(tableView)
        self.createUI()
        
        if businessDetailType == .businessCardDetailMine {
           self.addDefaultButtonTextRight("删除")
        }
    }
    
    func getData(){
         self.contentArray = [mineBusinessCardData?.job as Any,mineBusinessCardData?.name as Any,mineBusinessCardData?.email as Any
            ,mineBusinessCardData?.wechat as Any,mineBusinessCardData?.phone as Any,mineBusinessCardData?.alipay as Any]
    }
    
    override func rightTextBtn(_ sender: UIBarButtonItem) {
        self.deleteCard()
    }
    
    func createUI(){
        let urlStr = (mineBusinessCardData?.photo)!
        let name = (mineBusinessCardData?.name)?.removingPercentEncoding
        let addrsss = (mineBusinessCardData?.address)?.removingPercentEncoding
        
        self.headView.AvatarImageView.sd_setImage(with: NSURL(string: urlStr)! as URL, placeholderImage: UIImage.init(named: "morentouxiang"))
        self.headView.nameLabel.text = name
        self.headView.addressLabel.text = addrsss
    }
    
    func deleteCard(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let id = (mineBusinessCardData?.id)!
        let parameters:[String:Any] = ["id":id,"user_id":user_id]
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIBusinessDeleteMyCard, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == 100 {
                    WLInfo(LanguageHelper.getString(key: "delete_sucess"))
                    self.delegate?.businessCardDetailReloadData()
                }else{
                    WLInfo(responseData?.msg)
                }
            }
        }) { (error) in
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BusinessCardUX.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return BusinessCardUX.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: BusinessCardUX.sectionHeight))
        view.backgroundColor = R_UIThemeBackgroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCardCellIdentifier, for: indexPath) as! BusinessCardCell
        cell.selectionStyle = .none
        let title = titleArray[indexPath.row] as? String;
        let content = contentArray[indexPath.row] as? String
        cell.titleLabel.text = title?.removingPercentEncoding
        cell.contentLabel.text = content?.removingPercentEncoding
        return cell
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessCardCell", bundle: nil),forCellReuseIdentifier: self.businessCardCellIdentifier)
        tableView.backgroundColor = R_UIThemeBackgroundColor
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableHeaderView = self.headView
        tableView.tableFooterView = UIView()
        return tableView
    }()

    lazy var headView: BusinessCardView = {
        let view = Bundle.main.loadNibNamed("BusinessCardView", owner: nil, options: nil)?.last as! BusinessCardView
        view.frame = CGRect(x: 0, y: 0, width:SCREEN_WIDTH, height: BusinessCardUX.headHeight)
        return view
    }()
}
