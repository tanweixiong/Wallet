//
//  TransactionCoinVC.swift
//  Wallet
//
//  Created by tam on 2017/9/14.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD

class TransactionCoinVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate {
    
    enum transactionStyle: Int {
        case generalType = 0
        case specialType = 1
    }

    var mytransactionStyle = transactionStyle.generalType
    @IBOutlet weak var remainderMoneyLabel: UILabel!
    @IBOutlet weak var sumMoneyLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var transferAccountsButton: UIButton!
    @IBOutlet weak var receivablesButton: UIButton!
    @IBOutlet weak var otherReceivablesButton: UIButton!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var specialView: UIView!
    @IBOutlet weak var transactionCoinVw: UIView!
    @IBOutlet weak var transactionCoinTitleVw: UIView!
    fileprivate let transactionCoinIdentifier = "TransactionCoinIdentifier"
    fileprivate let cellHeight:CGFloat = 44
    fileprivate let corner:CGFloat = 20
    fileprivate var dataScore = NSMutableArray()
    fileprivate var page:Int = 1
    var assetsListModel = AssetsListModel()
    
    @IBOutlet weak var recentRecordsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarBgAlpha = "1"
        self.title = assetsListModel.coin_name
        self.addDefaultBackBarButtonLeft()
        self.createUI()
        self.getData()
        self.setTransactionStyle()
        self.setWebView()
        UIApplication.shared.keyWindow?.addSubview(tableViewDetailVw)
    }
    
    func createUI (){
        transactionCoinVw.addSubview(tableView)
        
        transferAccountsButton.clipsToBounds = true
        transferAccountsButton.layer.cornerRadius = corner
        
        receivablesButton.clipsToBounds = true
        receivablesButton.layer.cornerRadius = corner
        
        otherReceivablesButton.clipsToBounds = true
        otherReceivablesButton.layer.cornerRadius = corner
        
        self.remainderMoneyLabel.text = assetsListModel.remainderMoney?.stringValue
        self.sumMoneyLabel.text = "≈¥" + (assetsListModel.sumMoney?.stringValue)!
        
        recentRecordsLabel.text = LanguageHelper.getString(key: "recent_records")
        
        
        transferAccountsButton.setTitle(LanguageHelper.getString(key: "transfer"), for: .normal)
        receivablesButton.setTitle(LanguageHelper.getString(key: "receipt"), for: .normal)
        otherReceivablesButton.setTitle(LanguageHelper.getString(key: "receipt"), for: .normal)
    }
    
    func getData(){
        let user_id = UserDefaults.standard.getUserInfo().userId
        let coin_no = (assetsListModel.coin_no)?.stringValue
        let parameters:[String:Any] = ["userId":user_id,"page":"\(page)","flag":coin_no!]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIGetBill, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<TransactionCoinModel>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == "100" {
                    self.page = self.page + 1
                    let array = NSMutableArray()
                    array.addObjects(from: (responseData?.data?.data)!)
                    array.addObjects(from: self.dataScore as! [Any])
                    self.dataScore = array
                    self.tableView.reloadData()
                }
            }
            self.tableView.mj_header.endRefreshing()
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func setTransactionStyle(){
        switch mytransactionStyle {
        case transactionStyle.generalType:
            generalView.isHidden = false
            break
        case transactionStyle.specialType:
            specialView.isHidden = false
            break
        }
    }
    
    func setWebView(){
        let id:String = (assetsListModel.coin_no?.stringValue)!
        let url:NSURL = NSURL.init(string: ConstAPI.kAPIMYBaseURL + "index.html?" + "coinNo=" + "\(id)" + "&" + "type=" + "1min")!
        print(url)
        webView.delegate = self
        webView.loadRequest(NSURLRequest(url: url as URL) as URLRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
//        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "Loading"), maskType: .black)
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

    //转账
    @IBAction func transferAccountsOnClick(_ sender: UIButton) {
        let vc = TransferAccountsVC()
        vc.coinName = assetsListModel.coin_name!
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    //收款
    @IBAction func receivablesOnClick(_ sender: UIButton) {
        let vc = ReceivablesCodeVC()
        vc.coinName = assetsListModel.coin_name!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataScore.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: transactionCoinIdentifier, for: indexPath) as! TransactionCoinCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.amountLabel.text = LanguageHelper.getString(key: "transaction_amount")
            cell.dataLabel.text = LanguageHelper.getString(key: "transaction_data")
            cell.typeLabel.text = LanguageHelper.getString(key: "transaction_type")
        }else{
            let model = dataScore[indexPath.row - 1] as! TransactionList
            cell.amountLabel.text = model.money?.stringValue
            cell.dataLabel.text =  model.beginDate
            cell.typeLabel.text = model.operate
            
            if model.operate == "转出" {
                cell.typeLabel.text = LanguageHelper.getString(key: "trans_out")
            }
            if model.operate == "转入" {
                cell.typeLabel.text = LanguageHelper.getString(key: "home_Turn_In")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let model = dataScore[indexPath.row - 1] as! TransactionList
            tableViewDetailVw.isHidden = false
            self.tableViewDetailVw.serialNumberRLabel.text = model.serialNumber
            self.tableViewDetailVw.payeeRLabel.text = model.userId
            self.tableViewDetailVw.transactionTypeRLabel.text = model.operate
            self.tableViewDetailVw.transactionAmountRLabel.text = model.money?.stringValue
            self.tableViewDetailVw.dataRLabel.text = model.beginDate
            self.tableViewDetailVw.remarkRLabel.text = model.remark
            if model.operate == "转出" {
                self.tableViewDetailVw.transactionTypeRLabel.text = LanguageHelper.getString(key: "trans_out")
            }
            if model.operate == "转入" {
                self.tableViewDetailVw.transactionTypeRLabel.text = LanguageHelper.getString(key: "home_Turn_In")
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y:self.transactionCoinTitleVw.frame.maxY , width: SCREEN_WIDTH, height: self.transactionCoinVw.frame.height - self.transactionCoinTitleVw.frame.maxY ))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TransactionCoinCell", bundle: nil),forCellReuseIdentifier: self.transactionCoinIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getData()
        })
        return tableView
    }()
    
    lazy var tableViewDetailVw: TransactionCoinDetailVw = {
        let view = Bundle.main.loadNibNamed("TransactionCoinDetailVw", owner: nil, options: nil)?.last as! TransactionCoinDetailVw
        view.isHidden = true
        view.frame = (UIApplication.shared.keyWindow?.bounds)!
        view.backgroundColor = UIColor.R_UIRGBColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
