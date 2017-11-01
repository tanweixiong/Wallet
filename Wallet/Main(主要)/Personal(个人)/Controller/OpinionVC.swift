//
//  OpinionVC.swift
//  Wallet
//
//  Created by tam on 2017/9/22.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import YYText
import SVProgressHUD
import ObjectMapper

class OpinionVC: WLMainViewController,YYTextViewDelegate {
    
    @IBOutlet weak var textViewBackground: UIView!
    
    @IBOutlet weak var phoneAndMailTF: UITextField!
    
    @IBOutlet weak var suggestionButton: UIButton!
    
    @IBOutlet weak var bugButton: UIButton!
    
    @IBOutlet weak var selectTheTypeLabel: UILabel!
    
    fileprivate var feed_type = "0"
    
    fileprivate let feedbackMessage = LanguageHelper.getString(key: "edit_feedback")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        self.addDefaultButtonTextRight(LanguageHelper.getString(key: "submit"))
        self.createUI()
        self.title = LanguageHelper.getString(key: "submit")
        self.view.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xF5F6F8)
        self.textViewBackground.addSubview(self.textView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recoveryKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func rightTextBtn(_ sender: UIBarButtonItem) {
        self.closeKeyboard()
        if checkInput() {
            let user_id = UserDefaults.standard.getUserInfo().userId
            let contact = phoneAndMailTF.text!
            let feed:String = (textView?.text!)!
            let parameters:[String:Any] = ["feed_type":self.feed_type,"feed":feed,"contact":contact,"user_id":user_id]
            NetWorkTool.request(requestType: .post, URLString: ConstAPI.kAPIFeedsAdd, parameters: parameters, showIndicator: true, success: { (json) in
                let responseData = Mapper<ResponseData>().map(JSONObject: json)
                if responseData?.code == 100 {
                    let time: TimeInterval = 0.5
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "submit_successfully"))
                    }
                }else{
                    SVProgressHUD.showInfo(withStatus: responseData?.msg)
                }
            }, failture: { (error) in
                
            })
        }
    }
    
    override func backToPrevious() {
        self.navBarBgAlpha = "0"
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkInput()->Bool {
        if textView?.text.characters.count == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "please_input_feedback"))
            return false
        }
        
        if !Tools.validateEmail(email: phoneAndMailTF.text!) && !Tools.validateMobile(mobile: phoneAndMailTF.text!) {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "please_fill_finish"))
            return false
        }
        return true
    }
    
    @IBAction func feedBack(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 1 {
           let mistake = self.view.viewWithTag(2) as! UIButton
           mistake.isSelected = false
           self.feed_type = "0"
        }else{
          let mistake = self.view.viewWithTag(1) as! UIButton
          mistake.isSelected = false
          self.feed_type = "1"
        }
    }
    
    func createUI(){
        self.suggestionButton.setTitle(LanguageHelper.getString(key: "suggestion"), for: .normal)
        self.bugButton.setTitle(LanguageHelper.getString(key: "bug"), for: .normal)
        self.phoneAndMailTF.placeholder = LanguageHelper.getString(key: "please_fill")
        self.selectTheTypeLabel.text = LanguageHelper.getString(key: "select_feedback_type")
    }
    
    lazy var textView:YYTextView? = {
        let view = YYTextView.init(frame: CGRect.init(x: 0, y: 0, width:self.textViewBackground.frame.size.width, height: self.textViewBackground.frame.size.height))
        view.delegate = self
        view.placeholderText = self.feedbackMessage
        view.placeholderFont = UIFont.systemFont(ofSize: 14)
        view.placeholderTextColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 14)
        view.layer.masksToBounds = true
        return view
    }()
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }

}
