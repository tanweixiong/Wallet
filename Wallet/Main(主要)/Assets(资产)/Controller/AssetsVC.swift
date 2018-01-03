//
//  AssetsVC.swift
//  Wallet
//
//  Created by tam on 2017/8/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD
import SDWebImage

class AssetsVC: WLMainViewController, UITableViewDelegate, UITableViewDataSource,LBXScanViewControllerDelegate,AssetsDetailsDelegate {
    fileprivate var refreshFooterView = SDRefreshFooterView()
    fileprivate let assetsViewCellIdentifier = "AssetsViewCellIdentifier"
    fileprivate let cellHeight :CGFloat = 80
    fileprivate let headHeight :CGFloat = 300
    fileprivate var dataScore  = Array<Any>()
    fileprivate var headDataScore = NSMutableArray()
    fileprivate let photoAlbum = LJXPhotoAlbum()
    fileprivate let qrViewSize = CGSize.init(width: 260, height: 260)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDefaultButtonImageRight("anymore")
        self.navBarBgAlpha = "0"
        self.getHeadData(true)
        self.getListData()
        self.getMarkertData()
        self.autoLogin()
        self.view.addSubview(tableView)
        self.view.addSubview(navigationBar)
        NotificationCenter.default.addObserver(self, selector: #selector(AssetsVC.setReloadAssets), name: NSNotification.Name(rawValue: "setReloadAssets"), object: nil)
        ReachabilityConfiguration.checkNetworkStates()
    }
    
    override func rightImageBtn(_ sender: UIBarButtonItem) {
        self.addPopupView()
    }
    
    //获取下部分参数
    func getListData() {
        let userId = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":userId]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIMyWallet, parameters: parameters, showIndicator: true, success: { (json) in
           let responseData = Mapper<AssetsModel>().map(JSONObject: json)
           if let code = responseData?.code {
               if code == 100 {
                self.dataScore = (responseData?.data)!
                self.tableView.reloadData()
               }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
            if responseData?.msg == "无效令牌" {
               LoginVC.setTokenInvalidation()
            }
            }
                self.refreshFooterView.endRefreshing()
                self.tableView.mj_header.endRefreshing()
        }) { (error) in
                self.refreshFooterView.endRefreshing()
                self.tableView.mj_header.endRefreshing()
        }
    }
    
    //获取上部分参数
    func getHeadData(_ isfirst:Bool) {
        let user_ids = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_ids":user_ids]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIMyAnyWallet, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<AssetsModel>().map(JSONObject: json)
            if responseData?.code == 100 {
               let array:Array = (responseData?.data)!
                if isfirst == true {
                    self.headDataScore.removeAllObjects()
                    self.headDataScore.addObjects(from: array)
                    self.tableView.tableHeaderView = self.assetsCarouselView
                    self.tableView.reloadData()
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_AssetsReloadAssetsMassage), object: array)
                }
            }else {
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
            self.refreshFooterView.endRefreshing()
            self.tableView.mj_header.endRefreshing()
        }) { (error) in
            self.refreshFooterView.endRefreshing()
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func autoLogin(){
        if (UserDefaults.standard.object(forKey: R_Theme_UserPwdKey) != nil) {
            let phone = UserDefaults.standard.getUserInfo().phone
            let password = UserDefaults.standard.object(forKey: R_Theme_UserPwdKey) as! String
            let parameters = ["phone" :phone,"password" : password]
            Tools.loginToRefeshToken(parameters: parameters, haveParams: true, refreshSuccess: { (code, msg) in
            }, refreshFailture: { (error) in
            })
        }
    }
    
    //上传头像
    func uploadpictures(image:UIImage,addView:AssetsCarouselView,index:Int) {
        let userId = UserDefaults.standard.getUserInfo().userId
        let urlString = ConstAPI.kAPIUploadPhoto
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"), maskType: .black)
        NetWorkTool.uploadPictures(url: urlString, parameter:["userId":userId], image: image, imageKey: "photo", success: { (success) in
            if (success["data"] != nil) {
                let url = success["data"] as! String
                //重新存储
                let userInfo = UserDefaults.standard.getUserInfo()
                userInfo.photo = url
                UserDefaults.standard.saveCustomObject(customObject:userInfo, key: R_UserInfo)
                //改变视图
                addView.setAvatar(index,url)
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "upload_failed"))
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "upload_failed"))
        }
    }
    
    //获取行情网络数据并保存在本地
    func getMarkertData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIMyMarket, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<IndustryListModel>().map(JSONObject: json)
            if responseData?.code == 100 {
                let object:NSDictionary = json as! NSDictionary
                let data = object.object(forKey: "data") as! NSArray
                Tools.savePlaceOnFile(R_UserDefaults_Market_Key, data)
            }else if responseData?.code == 200 {
                LoginVC.setTokenInvalidation()
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
        }) { (error) in
            
        }
    }
    
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    //右侧导航
    func addPopupView() {
        PopupView.addCell(withIcon: UIImage.init(named: "home_saoyisao"), text: LanguageHelper.getString(key: "scan")) {
            let assets = WalletOCTools.getCurrentVC()
            let vc = LBXScanViewController();
            vc.title = LanguageHelper.getString(key: "scan")
            vc.scanStyle = vc.setCustomLBScan()
            vc.scanResultDelegate = self
            vc.navBarBgAlpha = "1"
            assets?.navigationController?.pushViewController(vc, animated: true)
        }
        
        PopupView.addCell(withIcon: UIImage.init(named: "home_wallet"), text:  LanguageHelper.getString(key: "create_wallet")) {
            var topRootViewController:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
            while (topRootViewController.presentedViewController != nil){
                topRootViewController = topRootViewController.presentedViewController!;
            }
            topRootViewController.present(CreateMyWalletVC(), animated: true, completion: {
                
            })
        }
        
        PopupView.popupView()
    }
    
    //扫描正确后操作
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        let resultStr = scanResult.strScanned!
        if resultStr.contains(R_Theme_QRECZCode) == false {
            if resultStr.contains(R_Theme_QRCode) {
                self.codeConfiguration(scanResult: resultStr, codeKey: R_Theme_QRCode)
            }else {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "qrCode_error"))
                return
            }
        }
    }
    
    func codeConfiguration(scanResult:String,codeKey:String){
        //扫描正确后操作
        CodeConfiguration.codeProcessing(self, ConstTools.getCodeMessage(scanResult, codeKey: R_Theme_QRCode)! as NSArray, success: { (address,type,data)  in
            let assets = WalletOCTools.getCurrentVC()
            if type == "1" {
                let addAContactVC = AddAContactVC()
                addAContactVC.contactsId = address
                assets?.navigationController?.pushViewController(addAContactVC, animated: true)
            }else if type == "2" {
                let transferAccountsVC = TransferAccountsVC()
                transferAccountsVC.receiveAddressString = address
                assets?.navigationController?.pushViewController(transferAccountsVC, animated: true)
            }else if type == "3" {
                let dict =  (WalletOCTools.getDictionaryFromJSONString(data))!
                let responseData = Mapper<MineBusinessCardData>().map(JSONObject: dict)
                let model:MineBusinessCardData = (responseData)!
                let responseCodeData = Mapper<MineBusinessCardCodeDataModel>().map(JSONObject: dict)
                let codeModel:MineBusinessCardCodeDataModel = (responseCodeData)!
                var ids = String(describing: codeModel.id)
                ids = ids.replacingOccurrences(of: "Optional(", with: "")
                ids = ids.replacingOccurrences(of: ")", with: "")
                model.id = ids
                let addBusiessCardVC = AddBusiessCardVC()
                addBusiessCardVC.mineBusinessCardData = model
                addBusiessCardVC.addBusinessCardType = .addBusiessFriendCard
                addBusiessCardVC.busiessCardType = .addBusiessFriendCard
                assets?.navigationController?.pushViewController(addBusiessCardVC, animated: true)
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataScore.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataScore[indexPath.row] as! AssetsListModel
        let vc = TransactionCoinVC()
        vc.mytransactionStyle = .generalType
        vc.assetsListModel = model
        self.pushNextViewController(vc, true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: assetsViewCellIdentifier, for: indexPath) as! AssetsViewCell
        cell.selectionStyle = .none
        let model = self.dataScore[indexPath.row] as! AssetsListModel
        
        cell.sumMoneyLabel.text = "≈ ¥ " + Tools.setAccuracy(data: model.sumMoney!)
        cell.allMoneyLabel.text = Tools.setAccuracy(data: model.remainderMoney!)
        
        cell.icon_nameLabel.text = model.coin_name
        cell.iconImageView.sd_setImage(with: NSURL(string: model.coinIcon!)! as URL, placeholderImage: UIImage.init(named: "jiazaimoren"))
        
        cell.iconImageView.clipsToBounds = true
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width/2
        
        cell.transformationButton.tag = indexPath.row
        cell.transformationButton.setTitle(LanguageHelper.getString(key: "convert"), for: .normal)
        cell.transformationBlock = { (sender:UIButton) in
            let model = self.dataScore[sender.tag] as! AssetsListModel
            if self.checkITC(coinName:model.coin_name!){
                let vc = CurrencyConversionVC()
                vc.assetsListModel = model
                self.pushNextViewController(vc, true)
            }else{
                let vc = CurrencyConversionNumberVC()
                //转出 当前
                vc.coin_assetsListModel = self.dataScore[indexPath.row] as! AssetsListModel
                
                //转入
                let assetsListDetailsModel = AssetsListDetailsModel()
                assetsListDetailsModel?.coin_name = "EC"
                assetsListDetailsModel?.coin_no = 0
                vc.change_assetsListModel = assetsListDetailsModel
                
                self.pushNextViewController(vc, true)
            }
        }
        return cell
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: -64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 45))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AssetsViewCell", bundle: nil),forCellReuseIdentifier: self.assetsViewCellIdentifier)
        tableView.backgroundColor = R_UIThemeBackgroundColor
        tableView.tableHeaderView = self.assetsCarouselDefaultView
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        self.refreshFooterView = SDRefreshFooterView.init()
        self.refreshFooterView.add(toScroll: tableView)
        self.refreshFooterView.addTarget(self, refreshAction: #selector(reloadData))
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.reloadData()
        })
        return tableView
    }()
    
    func reloadData(){
        self.getListData()
        self.getHeadData(false)
    }
    
    lazy var navigationBar: UIView = {
       let view = UIView()
       view.backgroundColor = R_UIThemeColor
       view.alpha = 0
       view.frame = CGRect(x: 0, y: -64, width: SCREEN_WIDTH, height: 64)
       return view
    }()

    lazy var assetsCarouselDefaultView: AssetsCarouselView = {
        let view = AssetsCarouselView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height:self.headHeight), dataArray: [], isFirst: true)
        view.assetsCarouselBlock = { (button) in
            self.pushAssetsDetails()
        }
        return view
    }()
    
    lazy var assetsCarouselView: AssetsCarouselView = {
        let view = AssetsCarouselView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height:self.headHeight), dataArray: self.headDataScore as! Array<Any>, isFirst: false)
        view.assetsCarouselBlock = { (button) in
            self.pushAssetsDetails()
        }
        view.assetsCarouselHeadBlock = {(userId,item) in
            self.photoAlbum.getOrTakeAPhoto(with: self) { (imgae) in
                self.uploadpictures(image: imgae!, addView: view, index: item)
            }
        }
        return view
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let offsetY :CGFloat = scrollView.contentOffset.y
    
        if offsetY < 0 {
//            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        if (offsetY < headHeight)
        {
            let alpha:CGFloat = 1/(headHeight/offsetY)
            navigationBar.alpha = alpha < 0 ? 0 : alpha
        }
        else
        {
            navigationBar.alpha = 1
        }
    }
    
    func pushAssetsDetails(){
        let vc = AssetsDetailsVC()
        vc.delegate = self
        self.pushNextViewController(vc, true)
    }
    
    func setReloadAssets(){
        self.getListData()
        self.getHeadData(false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("setReloadAssets"), object: nil)
    }

    func checkITC(coinName:String) ->Bool{
        if coinName == "EC" {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


