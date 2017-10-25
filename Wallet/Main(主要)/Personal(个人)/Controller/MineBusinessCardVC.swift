//
//  MineBusinessCardVC.swift
//  Wallet
//
//  Created by tam on 2017/10/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class MineBusinessCardVC: WLMainViewController,UIScrollViewDelegate,BusinessCardDelegate,BusinessCardDetailDelegate {
    
    fileprivate var dataScore:NSArray = NSArray()
    fileprivate var dataArray:NSArray = NSArray()
    fileprivate var avatarImageView = UIImageView()
    
    struct MineBusinessCardUX {
        static let avatarSize:CGSize = CGSize(width: XMAKE(50), height: XMAKE(50))
        static let nameFont:CGFloat = 14
        static let mineBusinessSize:CGSize = CGSize(width: SCREEN_WIDTH - 40, height: YMAKE(300))
        static let pageControlSize:CGSize = CGSize(width: SCREEN_WIDTH, height: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navBarBgAlpha = "1"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getImage()
        self.addDefaultBackBarButtonLeft()
        self.title = LanguageHelper.getString(key: "my_card")
        self.navBarBgAlpha = "1"
        self.addDefaultButtonTextRight(LanguageHelper.getString(key: "mine_add"))
        self.getData()
    }
    
    override func rightTextBtn(_ sender:UIBarButtonItem){
        let vc = AddBusiessCardVC()
        vc.busiessCardType = .addBusiessCard
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getImage(){
         let data:NSData = UserDefaults.standard.object(forKey: R_UIThemeAvatarKey) as! NSData
         let image:UIImage = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! UIImage
         self.avatarImageView.image = image
    }
    
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let parameters = ["user_id":user_id]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIBusinessMyCard, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<MineBusinessCardModel>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == 100 {
                    let dataDict:NSDictionary = json as! NSDictionary
                    self.dataArray = dataDict["data"] as! NSArray
                    
                    self.dataScore = (responseData?.data)! as NSArray
                    self.createUI(data: self.dataScore as NSArray)
                }
            }else{
                WLInfo(responseData!.msg)
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
    
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    func createUI(data:NSArray){
        let avatarUrl = UserDefaults.standard.getUserInfo().photo
        for item in 0...data.count - 1 {
            let model = data[item] as! MineBusinessCardData
            let x = CGFloat(20 + MineBusinessCardUX.mineBusinessSize.width * CGFloat(item) + CGFloat(20 * item))
            let view = Bundle.main.loadNibNamed("MineBusinessView", owner: nil, options: nil)?.last as! MineBusinessView
            view.frame = CGRect(x: x, y: 0 , width: MineBusinessCardUX.mineBusinessSize.width, height: MineBusinessCardUX.mineBusinessSize.height)
            view.backgroundColor = UIColor.R_UIRGBColor(red: 245, green: 245, blue: 245, alpha: 1)
            view.nameLabel.text = (model.name)!.removingPercentEncoding
            
//            view.avatarImageView.sd_setImage(with: NSURL(string: avatarUrl)! as URL, placeholderImage: UIImage.init(named: "jiazaimoren"))
            
            let jsonStr = WalletOCTools.getJSONString(fromDictionary: self.dataArray[item])
            view.codeImageView.image = Tools.createQRForStringCodeUrl(qrString: CodeConfiguration.getCardCodeConfiguration("3", jsonStr!), imageView: self.avatarImageView)
            
            view.modifyButton.tag = item
            view.detailBtn.tag = item
            view.mineBusinessCallBack = {(sender:UIButton) in
                let vc = AddBusiessCardVC()
                vc.busiessCardType = .updateBusiessCard
                vc.mineBusinessCardData = self.dataScore[sender.tag] as? MineBusinessCardData
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            view.businessDatilCallBack = {(sender:UIButton) in
                let vc = BusinessCardVC()
                vc.delegate = self
                vc.mineBusinessCardData = self.dataScore[sender.tag] as? MineBusinessCardData
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.scrollView.addSubview(view)
        }
        let width = CGFloat(data.count) * MineBusinessCardUX.mineBusinessSize.width + 20 + 20 * CGFloat(data.count)
        self.scrollView.contentSize = CGSize(width: width - 20, height: MineBusinessCardUX.mineBusinessSize.height)
        view.addSubview(self.scrollView)
        
        pageControl.numberOfPages = data.count
        pageControl.frame = CGRect(x: 0, y: scrollView.frame.maxY + 10, width: MineBusinessCardUX.pageControlSize.width, height: MineBusinessCardUX.pageControlSize.height)
        view.addSubview(pageControl)
    }
    
    func businessCardReloadData(){
        self.clear()
        self.getData()
    }
    
    func businessCardDetailReloadData() {
        self.clear()
        self.getData()
    }
    
    func clear(){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
        self.pageControl.currentPage = page;
    }
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0 , y: YMAKE(100), width: SCREEN_WIDTH - 20.0, height: MineBusinessCardUX.mineBusinessSize.height)
        scrollView.isPagingEnabled = true;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.clipsToBounds = false;
        scrollView.bounces = false;
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()

    lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.R_UIRGBColor(red: 207, green: 213, blue: 216, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor.R_UIRGBColor(red: 151, green: 171, blue: 182, alpha: 1)
        return pageControl
    }()
 
    override func backToPrevious() {
        self.navBarBgAlpha = "0"
        self.navigationController?.popViewController(animated: true)
    }
    
}
