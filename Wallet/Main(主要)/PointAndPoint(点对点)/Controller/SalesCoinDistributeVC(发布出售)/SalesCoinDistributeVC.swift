//
//  SalesCoinDistributeVC.swift
//  Wallet
//
//  Created by tam on 2018/1/9.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import YYText
//import IQKeyboardManager

class SalesCoinDistributeVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YYTextViewDelegate,AssetsDetailsSelectDelegate {
    fileprivate let headingContent = ["币种选择","货币","价格","最小量","最大量","收款方式","备注"]
    fileprivate let mineInformationListCell = "MineInformationListCell"
    fileprivate let salesCoinDistributeRemarkCell = "SalesCoinDistributeRemarkCell"
    fileprivate let foodReservationCell = "FoodReservationCell"
    fileprivate var remarkCell = SalesCoinDistributeRemarkCell()
    fileprivate var listCell = MineInformationListCell()
    fileprivate var headCell = FoodReservationCell()
    fileprivate var textFieldRect = CGRect()
    
    fileprivate var coinTF = UITextField()
    fileprivate var currencyTF = UITextField()
    fileprivate var priceTF = UITextField()
    fileprivate var minimumTF = UITextField()
    fileprivate var maxmumTF = UITextField()
    fileprivate var paymentMethodTF = UITextField()
    fileprivate var ramark = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "发布出售"
        self.addDefaultBackBarButtonLeft()
        self.view.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func postSaleTranslation(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.shared().isEnabled = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Float
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let keyboardH:CGFloat = (keyboardRect?.size.height)!
        UIView.animate(withDuration: TimeInterval(duration)) {
            if keyboardH > 200 {
                let textFileHeight = self.textFieldRect.maxY
                let maxY = SCREEN_HEIGHT - keyboardH
                //计算被挡住的距离
                if textFileHeight > maxY {
                    let height = textFileHeight - maxY
                    self.view.frame = CGRect(x: 0, y: -height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Float
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.view.frame = CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         let content:UIView = view.superview!
         let cell:UIView = content.superview!
         textFieldRect = cell.frame
          return true
    }
    
    func textViewShouldBeginEditing(_ textView: YYTextView) -> Bool {
        let content:UIView = textView.superview!
        let cell:UIView = content.superview!
        textFieldRect = cell.frame
         return true
    }
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var maxLength:Int = 0
        if textView == self.remarkCell.textView {
            maxLength = 100
        }
        //限制长度
        let proposeLength = (textView.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + text.lengthOfBytes(using: String.Encoding.utf8)
        if proposeLength > maxLength { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headingContent.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let assetsDetailsVC = AssetsDetailsVC()
            assetsDetailsVC.selectDelegate = self
            assetsDetailsVC.status = .select
            self.navigationController?.pushViewController(assetsDetailsVC, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6 {
            return UserDefaults.standard.object(forKey: "height") != nil ? UserDefaults.standard.object(forKey: "height") as! CGFloat : 0
        }else{
            return 54
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 6 {
            remarkCell = tableView.dequeueReusableCell(withIdentifier: salesCoinDistributeRemarkCell, for: indexPath) as! SalesCoinDistributeRemarkCell
            remarkCell.selectionStyle = .none
            remarkCell.setData()
            remarkCell.textView?.delegate = self
            return remarkCell
        }else{
            if indexPath.row == 0 {
                headCell = tableView.dequeueReusableCell(withIdentifier: foodReservationCell, for: indexPath) as! FoodReservationCell
                headCell.selectionStyle = .none
                headCell.headingLabel.text = "币种选择"
                headCell.dataLabel.text = "请选择"
              return headCell
            }else{
                listCell = tableView.dequeueReusableCell(withIdentifier: mineInformationListCell, for: indexPath) as! MineInformationListCell
                listCell.selectionStyle = .none
                listCell.tag = indexPath.row
                listCell.headingLabel.text = headingContent[indexPath.row]
                listCell.textfield.delegate = self
                return listCell
            }
        }
    }
    
    func assetsDetailsChooseCurrency(coin: String, coinNumber: String) {
         headCell.dataLabel.text = coin
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.closeKeyboard()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT_INSIDE))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MineInformationListCell", bundle: nil),forCellReuseIdentifier: self.mineInformationListCell)
        tableView.register(UINib(nibName: "SalesCoinDistributeRemarkCell", bundle: nil),forCellReuseIdentifier: self.salesCoinDistributeRemarkCell)
        tableView.register(UINib(nibName: "FoodReservationCell", bundle: nil),forCellReuseIdentifier: self.foodReservationCell)
        tableView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xEDEDED)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UILineColor
        return tableView
    }()

}
