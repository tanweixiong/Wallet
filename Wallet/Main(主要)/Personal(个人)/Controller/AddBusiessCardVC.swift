//
//  AddBusiessCardVC.swift
//  Wallet
//
//  Created by tam on 2017/10/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import IQKeyboardManager
import SVProgressHUD

enum BusiessCardType {
    case addBusiessCard
    case updateBusiessCard
    case addBusiessFriendCard
}

enum AddBusinessCardType {
    case addBusiessMyCard
    case addBusiessFriendCard
}

public protocol BusinessCardDelegate {
    func businessCardReloadData()
}

class AddBusiessCardVC: WLMainViewController, UITableViewDelegate,UITableViewDataSource {
    fileprivate let addMineBusinessCardCellIdentifier = "AddMineBusinessCardCellIdentifier"
    fileprivate let addMineBusinessCardHeadCellIdentifier = "AddMineBusinessCardHeadCellIdentifier"
    fileprivate let titleArray:NSArray = [LanguageHelper.getString(key: "card_avatar"),LanguageHelper.getString(key: "card_name"),LanguageHelper.getString(key: "card_job"),LanguageHelper.getString(key: "card_mall"),LanguageHelper.getString(key: "card_phone"),LanguageHelper.getString(key: "card_weChat"),LanguageHelper.getString(key: "card_other"),LanguageHelper.getString(key: "card_address")]
    fileprivate var contentArray = NSArray()
    fileprivate let photoAlbum = LJXPhotoAlbum()
    fileprivate var minePhoto =  UserDefaults.standard.getUserInfo().photo
    var  mineBusinessCardData = MineBusinessCardData()
    struct AddBusiessUX{
        static let sectionHeight:CGFloat = 16
        static let rowHeight:CGFloat = 54
        static let headHeight:CGFloat = 194
        static let placeholderFont:CGFloat = 14
    }
    
    var busiessCardType = BusiessCardType.addBusiessCard
    var addBusinessCardType = AddBusinessCardType.addBusiessMyCard
    var delegate:BusinessCardDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCloseRoundKeyboard()
        self.addDefaultBackBarButtonLeft()
        self.view.backgroundColor = R_UIThemeBackgroundColor

        self.title = busiessCardType == .addBusiessCard || busiessCardType == .addBusiessFriendCard ? LanguageHelper.getString(key: "add_card") : LanguageHelper.getString(key: "modify_card")

        self.addDefaultButtonTextRight(LanguageHelper.getString(key: "card_finish"))
        view.addSubview(tableView)

        if busiessCardType == .updateBusiessCard || busiessCardType == .addBusiessFriendCard{
            self.contentArray = ["头像"
                                 ,(mineBusinessCardData?.name)!
                                ,(mineBusinessCardData?.job)!
                                ,(mineBusinessCardData?.email)!
                                ,(mineBusinessCardData?.phone)!
                                ,(mineBusinessCardData?.wechat)!
                                ,(mineBusinessCardData?.alipay)!
                                ,(mineBusinessCardData?.address)!]

        }
    }
    
    override func rightTextBtn(_ sender:UIBarButtonItem) {
        if busiessCardType == .addBusiessCard {
            self.addCard()
        }else if busiessCardType == .updateBusiessCard {
            self.updateMyCard()
        }else{
            self.addFriendCard()
        }
    }
    
    //添加名片
    func addCard(){
            let nameCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0) )as! AddMineBusinessCardCell
            let jobCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0) )as! AddMineBusinessCardCell
            let mallCell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0) )as! AddMineBusinessCardCell
            let phoneCell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0) )as! AddMineBusinessCardCell
            let weChatCell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0) )as! AddMineBusinessCardCell
            let alpayCell = self.tableView.cellForRow(at: IndexPath(row: 6, section: 0) )as! AddMineBusinessCardCell
            let addressCell = self.tableView.cellForRow(at: IndexPath(row: 7, section: 0) )as! AddMineBusinessCardCell
            
            let name = nameCell.textField.text!
            if name == "" {
               SVProgressHUD.showInfo(withStatus: "请填写用户名")
               return
           }
        
            let job = jobCell.textField.text!
            let mall = mallCell.textField.text!
            let phone = phoneCell.textField.text!
            let weChat = weChatCell.textField.text!
            let alipay = alpayCell.textField.text!
            let address = addressCell.textField.text!
            
            let userID = UserDefaults.standard.getUserInfo().userId
            let photo = self.minePhoto
  
            let parameters:[String :String] = ["job":job,"name":name,"email":mall,"wechat":weChat,"phone":phone,"alipay":alipay,"user_id":userID,"address":address,"photo":photo]
            
            let url = addBusinessCardType == .addBusiessMyCard ? ConstAPI.kAPIBusinessAdd : ConstAPI.kAPIFriendAddCardList
            
            NetWorkTool.request(requestType: .post, URLString: url, parameters: parameters, showIndicator: true, success: { (json) in
                let responseData = Mapper<MineBusinessCardModel>().map(JSONObject: json)
                if let code = responseData?.code {
                    if code == 100 {
                        WLInfo(LanguageHelper.getString(key: "add_sucess"))
                        self.delegate?.businessCardReloadData()
                        self.closeKeyboard()
                    }else{
                        WLInfo(responseData?.msg)
                    }
                }
            }) { (error) in
                
            }
    
    }
    
    //修改名片
    func updateMyCard(){
        
        let nameCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0) )as! AddMineBusinessCardCell
        let jobCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0) )as! AddMineBusinessCardCell
        let mallCell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0) )as! AddMineBusinessCardCell
        let phoneCell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0) )as! AddMineBusinessCardCell
        let weChatCell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0) )as! AddMineBusinessCardCell
        let alpayCell = self.tableView.cellForRow(at: IndexPath(row: 6, section: 0) )as! AddMineBusinessCardCell
        let addressCell = self.tableView.cellForRow(at: IndexPath(row: 7, section: 0) )as! AddMineBusinessCardCell
        
        let name = nameCell.textField.text!
        let job = jobCell.textField.text!
        let mall = mallCell.textField.text!
        let phone = phoneCell.textField.text!
        let weChat = weChatCell.textField.text!
        let alipay = alpayCell.textField.text!
        let address = addressCell.textField.text!
        
        let userID = UserDefaults.standard.getUserInfo().userId
        let photo = self.minePhoto
        let id:String = (mineBusinessCardData?.id)!
        
        let parameters:[String : String] = ["job":job,"name":name,"email":mall,"wechat":weChat,"phone":phone,"alipay":alipay,"user_id":userID,"photo":photo,"id":id,"address":address]
        let user = ConstAPI.kAPIUpdateMyCard
        NetWorkTool.request(requestType: .post, URLString: user, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<MineBusinessCardModel>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == 100 {
                    WLInfo(LanguageHelper.getString(key: "modify_card_finish"))
                    self.delegate?.businessCardReloadData()
                }else{
                    WLInfo(responseData?.msg)
                }
            }
        }) { (error) in
            
        }
    }
    
    func addFriendCard(){
        let userId = UserDefaults.standard.getUserInfo().userId
        let id = (mineBusinessCardData?.id)!
        let parameters = ["user_id":userId,"card_id":id]
        NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIFriendAddCardList, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<ResponseData>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == 100 {
                    WLInfo(LanguageHelper.getString(key: "add_sucess"))
                }else{
                    WLInfo(responseData?.msg)
                }
            }
        }, failture: { (error) in
            
        })
    }
    
    //上传头像
    func uploadpictures(image:UIImage) {
        let urlString = ConstAPI.kAPIBusinessUploadPhoto
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"), maskType: .black)
        NetWorkTool.uploadPictures(url: urlString, parameter:nil, image: image, imageKey: "photo", success: { (success) in
            if (success["data"] != nil) {
                let url = success["data"] as! String
                 let headViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0) )as! BusinessCardHeadCell
                 headViewCell.iconImageView.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: UIImage.init(named: "morentouxiang"))
                self.minePhoto = url
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "upload_failed"))
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "upload_failed"))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddBusiessUX.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addMineBusinessCardHeadCellIdentifier, for: indexPath) as! BusinessCardHeadCell
            cell.selectionStyle = .none
            cell.iconImageView.sd_setImage(with: NSURL(string: minePhoto)! as URL, placeholderImage: UIImage.init(named: "morentouxiang"))
            cell.iconImageView.clipsToBounds = true
            cell.layer.cornerRadius = cell.iconImageView.frame.size.width/2
            
            cell.businessCardHeadCallBack = {
                self.photoAlbum.getOrTakeAPhoto(with: self) { (image) in
                    self.uploadpictures(image: image!)
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: addMineBusinessCardCellIdentifier, for: indexPath) as! AddMineBusinessCardCell
            cell.selectionStyle = .none
            cell.titleLabel.text = titleArray[indexPath.row] as? String
            if busiessCardType == .addBusiessCard {
                let str = titleArray[indexPath.row] as? String
                cell.textField.placeholder = LanguageHelper.getString(key: "place_enter") + str!
            }else{
                let content = contentArray[indexPath.row] as? String
                cell.textField.text = content?.removingPercentEncoding
            }
            return cell
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AddMineBusinessCardCell", bundle: nil),forCellReuseIdentifier: self.addMineBusinessCardCellIdentifier)
        tableView.register(UINib(nibName: "BusinessCardHeadCell", bundle: nil),forCellReuseIdentifier: self.addMineBusinessCardHeadCellIdentifier)
        tableView.backgroundColor = R_UIThemeBackgroundColor
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = self.footView
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    lazy var footView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 300)
        return view
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.closeKeyboard()
    }
}
