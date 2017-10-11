//
//  SalesCoinVC.swift
//  Wallet
//
//  Created by tam on 2017/10/9.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class SalesCoinVC: WLMainViewController,UITableViewDataSource,UITableViewDelegate,WRCycleScrollViewDelegate {
    
    struct SalesCoinUX {
        static let cellHeight:CGFloat = 110
        static let salesCoinIdentifier = "salesCoinIdentifier"
        static let headHeight:CGFloat = 200
    }
    
    fileprivate let salesCoinIdentifier = "salesCoinIdentifier"
    fileprivate lazy var viewModel: SalesCoinVM = SalesCoinVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "交易"
        
        view.addSubview(self.tableView)
        viewModel.loadDataWithHandler {[weak self] (loadState) in
            guard let `self` = self else { return }
            switch loadState {
            case .success:
                self.tableView.reloadData()
            default: break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SalesCoinUX.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SalesCoinUX.salesCoinIdentifier, for: indexPath) as! SalesCoinCell
        cell.selectionStyle = .none
        cell.dataModel = viewModel.data.first!
        cell.salesCoinBlock = { (sender) in
             self.pushNextViewController(BuyCoinVC(), true)
        }
        return cell
    }
    
    lazy var currencyImageView: WRCycleScrollView = {
        let frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SalesCoinUX.headHeight)
        let serverImages = ["http://p.lrlz.com/data/upload/mobile/special/s252/s252_05471521705899113.png",
                            "http://p.lrlz.com/data/upload/mobile/special/s303/s303_05442007678060723.png",
                            "http://p.lrlz.com/data/upload/mobile/special/s303/s303_05442007587372591.png",
                            "http://p.lrlz.com/data/upload/mobile/special/s303/s303_05442007388249407.png",
                            "http://p.lrlz.com/data/upload/mobile/special/s303/s303_05442007470310935.png"]
        let scrollView = WRCycleScrollView(frame: frame, type: .SERVER, imgs: serverImages)
        scrollView.delegate = self
        scrollView.otherDotColor = UIColor.gray
        return scrollView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - 64 - 44))
        tableView.tableHeaderView = self.currencyImageView
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SalesCoinCell", bundle: nil),forCellReuseIdentifier: SalesCoinUX.salesCoinIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        return tableView
    }()
}
