//
//  FindVC.swift
//  Wallet
//
//  Created by tam on 2017/8/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class FindVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate let findCellIdentifier = "findCellIdentifier"
    fileprivate let cellHeight:CGFloat = 80
    fileprivate let dataScore = Array<Any>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  LanguageHelper.getString(key: "information")
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func  tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        view.backgroundColor = R_UIThemeColor
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: findCellIdentifier, for: indexPath) as! FindCell
        cell.selectionStyle = .none
        cell.backgroundColor = R_UIThemeColor
        cell.titleLabel.text = LanguageHelper.getString(key: "test_text1")
        cell.contentLabel.text = LanguageHelper.getString(key: "test_text2")
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 45 - 64))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FindCell", bundle: nil),forCellReuseIdentifier: self.findCellIdentifier)
        tableView.backgroundColor = R_UIThemeColor
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        return tableView
    }()

}
