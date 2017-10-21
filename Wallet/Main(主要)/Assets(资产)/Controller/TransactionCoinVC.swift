//
//  TransactionCoinVC.swift
//  Wallet
//
//  Created by tam on 2017/9/14.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import MJRefresh

class TransactionCoinVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource {
    
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
        let parameters = ["userId":user_id,"page":"\(page)","flag":"0"]
        NetWorkTool.request(requestType: .get, URLString: ConstAPI.kAPIGetBill, parameters: parameters, showIndicator: true, success: { (json) in
            let responseData = Mapper<TransactionCoinModel>().map(JSONObject: json)
            if let code = responseData?.code {
                if code == 100 {
                    self.page = self.page + 1
                    let array = NSMutableArray()
                    array.addObjects(from: (responseData?.data)!)
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
        return self.dataScore.count
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
        let model = dataScore[indexPath.row] as! TransactionList
        cell.titleLabel.text = model.paymentName
        cell.contentLabel.text = model.money?.stringValue
        cell.statusLabel.text = model.operate
        return cell
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y:self.transactionCoinTitleVw.frame.maxY , width: self.transactionCoinVw.frame.width, height: self.transactionCoinVw.frame.height - self.transactionCoinTitleVw.frame.maxY ))
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
