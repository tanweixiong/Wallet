//
//  editMarketVC.swift
//  Wallet
//
//  Created by tam on 2017/9/20.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD

protocol EditMarketDelegate:NSObjectProtocol{
    func editMarketReload()
}

class editMarketVC: WLMainViewController,UITableViewDataSource,UITableViewDelegate,ZFReOrderTableViewDelegate {

    var delegate:EditMarketDelegate?
    fileprivate let cellHeight:CGFloat = 100
    fileprivate let headHeight: CGFloat = 0.5
    fileprivate let dataScore = NSMutableArray()
    fileprivate let newArray = NSMutableArray()
    fileprivate let exchangeArray = NSMutableArray()
    fileprivate let editMarketCellIdentifier = "EditMarketCellIdentifier"
    fileprivate var reOrderView = ZFReOrderTableView()
    fileprivate var beginIndexPath = IndexPath()
    fileprivate let headViewHeight :CGFloat = 42
    fileprivate let headFont :UIFont = UIFont.systemFont(ofSize: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LanguageHelper.getString(key: "edit_market")
        self.navBarBgAlpha = "1"
        self.addDefaultBackBarButtonLeft()
        self.addDefaultButtonTextRight(LanguageHelper.getString(key: "save"))

        self.view.addSubview(headView)
        
        self.getData()
        
         self.reOrderView = ZFReOrderTableView.init(frame: CGRect(x: 0, y: headView.frame.height, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - headView.frame.height), with: dataScore, canReorder: true)
        self.reOrderView.tableView.delegate = self
        self.reOrderView.tableView.dataSource = self
        self.reOrderView.tableView.register(UINib(nibName: "editMarketCell", bundle: nil),forCellReuseIdentifier: self.editMarketCellIdentifier)
        self.reOrderView.tableView.backgroundColor = R_UIThemeColor
        self.reOrderView.tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH/2, 0,SCREEN_WIDTH/2);
        self.reOrderView.delegate = self
        self.view.addSubview(self.reOrderView)
    }
    
    //详情数据
    func getData(){
          let data:Array = Tools.getPlaceOnFile(R_UserDefaults_Market_Key) as! NSArray as Array
          self.newArray.addObjects(from: data)
          self.dataScore.add(self.newArray)
        
          self.exchangeArray.addObjects(from: data)
    }
    
    func zfReOrderTableViewBeginMove(_ beginIndexPath: IndexPath!) {
        self.beginIndexPath = beginIndexPath
//        let cell = self.reOrderView.tableView.cellForRow(at: beginIndexPath) as! editMarketCell
//        cell.lineView.isHidden = true
    }
    
    func zfReOrderTableViewEndMove(_ endIndexPath: IndexPath!) {
        self.exchangeArray.exchangeObject(at: endIndexPath.row, withObjectAt: self.beginIndexPath.row)
//        let cell = self.reOrderView.tableView.cellForRow(at: endIndexPath) as! editMarketCell
//        cell.lineView.isHidden = false
    }
    
    override func rightTextBtn(_ sender: UIBarButtonItem) {
        Tools.savePlaceOnFile(R_UserDefaults_Market_Key, self.exchangeArray)
        self.delegate?.editMarketReload()
        SVProgressHUD.showInfo(withStatus: "保存成功")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataScore.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataScore[section] as AnyObject).count as! Int
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = R_UIThemeColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: editMarketCellIdentifier, for: indexPath) as! editMarketCell
        cell.backgroundColor = R_UIThemeColor
        cell.selectionStyle = .none
        let array:NSArray = self.dataScore[indexPath.section] as! NSArray
        let data:NSDictionary = array[indexPath.row] as! NSDictionary
        cell.titleLabel.text = data["coin_name"] as? String
        return cell
    }
    
    lazy var headView: UIView = {
        let headView = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.headViewHeight)
        headView.backgroundColor = R_UIThemeColor
        headView.addSubview(self.nameLabel)
        headView.addSubview(self.riseLabel)
        headView.addSubview(self.newLabel)
        headView.layer.addSublayer(self.layers)
        headView.layer.addSublayer(self.layert)
        return headView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 0, width: SCREEN_WIDTH/2, height: self.headViewHeight)
        label.textColor = UIColor.white
        label.text = LanguageHelper.getString(key: "asset_name")
        label.font = self.headFont
        return label
    }()
    
    lazy var riseLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: SCREEN_WIDTH - SCREEN_WIDTH/3 - 20, y: 0, width: SCREEN_WIDTH/3, height: self.headViewHeight)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.text = LanguageHelper.getString(key: "drag")
        label.font = self.headFont
        return label
    }()
    
    lazy var newLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: SCREEN_WIDTH/2 + 15, y: 0, width: SCREEN_WIDTH/3, height: self.headViewHeight)
        label.textColor = UIColor.white
        label.text = LanguageHelper.getString(key: "remind")
        label.font = self.headFont
        return label
    }()
    
    lazy var layers: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: self.headViewHeight - 0.5, width: SCREEN_WIDTH , height: 0.5)
        layer.backgroundColor  =  UIColor.R_UIColorFromRGB(color: 0xdddddd).cgColor
        return layer
    }()
    
    lazy var layert: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH , height: 0.5)
        layer.backgroundColor  =  UIColor.R_UIColorFromRGB(color: 0xdddddd).cgColor
        return layer
    }()
    
}
