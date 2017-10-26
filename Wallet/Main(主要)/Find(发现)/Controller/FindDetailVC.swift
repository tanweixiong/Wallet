//
//  FindDetailVC.swift
//  Wallet
//
//  Created by tam on 2017/10/26.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class FindDetailVC: WLMainViewController,UIWebViewDelegate  {
    
    var findDetailModel = FindDetailModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯详情"
        self.addDefaultBackBarButtonLeft()
        self.setWebView()
    }
    
    func setWebView(){
        print((findDetailModel?.admin_id)!)
        webView.delegate = self
        let url:NSURL = NSURL.init(string: "http://47.52.59.119:9099/webview/about.html")!
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
        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "network_poor"))
    }

    let webView:UIWebView = {
        let view = UIWebView()
        return view
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
