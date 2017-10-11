//
//  AboutWeVC.swift
//  DHSWallet
//
//  Created by tam on 2017/9/7.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import SVProgressHUD

class AboutWeVC: WLMainViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDefaultBackBarButtonLeft()
        self.navBarBgAlpha = "1"
        self.title = LanguageHelper.getString(key: "about_us")
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "Loading"), maskType: .black)
        let url:NSURL = NSURL.init(string: "http://47.52.59.119:9099/webview/about.html")!
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
        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "network_poor"))
    }
    
    override func backToPrevious() {
        self.navBarBgAlpha = "0"
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
