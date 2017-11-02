//
//  IndustryDetailsVC.swift
//  Wallet
//
//  Created by tam on 2017/9/12.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD

class IndustryDetailsVC: WLMainViewController,UIWebViewDelegate {
    
    var coin_no:String = ""
    
    fileprivate let usdString:String = "$ "
    
    fileprivate let cnyString:String = "¥ "
    
    fileprivate let limitString:String = "%"
    
    @IBOutlet weak var coin_nameLabel: UILabel!
    
    @IBOutlet weak var cnyLabel: UILabel!
    
    @IBOutlet weak var usdLabel: UILabel!
    
    @IBOutlet weak var limitLabel: UILabel!
    
    @IBOutlet weak var p_openLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var p_hideLabel: UILabel!
    
    @IBOutlet weak var p_lowLabel: UILabel!
    
   fileprivate var dataScore = NSMutableArray()
    
    @IBOutlet weak var openingLabel: UILabel!
    
    @IBOutlet weak var highestLabel: UILabel!

    @IBOutlet weak var lowestLabel: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "market_detail")
        self.addDefaultBackBarButtonLeft()
        self.createUI()
        self.getData(coin_no)
        self.setLanguage()
        self.setWebView()
    }
    
    func getData(_ coin_no:String){
        let parameters = ["coin_no":coin_no]
        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "loading"))
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIThemarket, parameters: parameters, showIndicator: true, success: { (json) in
            SVProgressHUD.dismiss()
            let responseData = Mapper<IndustryMarkListModel>().map(JSONObject: json)
            if responseData?.code == 100{
                let model = responseData?.data
                let usd:String = String.init(format: "%.2f", (model?.usd!)!)
                let cny:String = String.init(format: "%.2f", (model?.cny!)!)
                self.p_lowLabel.text = self.cnyString + (responseData?.data?.p_last!.stringValue)!
                self.p_hideLabel.text = self.cnyString + (responseData?.data?.p_high!.stringValue)!
                self.p_openLabel.text = self.cnyString + (responseData?.data?.p_open!.stringValue)!
                self.amountLabel.text = self.cnyString + (responseData?.data?.amount!.stringValue)!
                self.usdLabel.text = self.usdString + usd
                self.cnyLabel.text = self.cnyString + cny
                self.limitLabel.text = (responseData?.data?.limit!.stringValue)! + self.limitString
                self.coin_nameLabel.text = responseData?.data?.coin_name!
            }else{
                SVProgressHUD.showInfo(withStatus: responseData?.msg)
            }
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }

    func createUI(){
        limitLabel.clipsToBounds = true
        limitLabel.layer.cornerRadius =  5
    }
    
    func setLanguage(){
        openingLabel.text = LanguageHelper.getString(key: "zero_openning")
        highestLabel.text = LanguageHelper.getString(key: "highest")
        lowestLabel.text = LanguageHelper.getString(key: "lowest")
        volumeLabel.text = LanguageHelper.getString(key: "volume")
    }
    
    func setWebView(){
//        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "Loading"), maskType: .black)
        let url:NSURL = NSURL.init(string: ConstAPI.kAPIMYBaseURL + "index.html?" + "coinNo=" + "\(coin_no)" + "&" + "type=" + "1min")!
        webView.delegate = self
        webView.loadRequest(NSURLRequest(url: url as URL) as URLRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let time: TimeInterval = 0.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            SVProgressHUD.dismiss()
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "network_poor"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
