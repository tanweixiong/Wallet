//
//  PersonalVC.swift
//  Wallet
//
//  Created by tam on 2017/8/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class PersonalVC: WLMainViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    fileprivate let cellTag:Int = 10000000
    fileprivate let headHeight:CGFloat = 175
    fileprivate let footHeight:CGFloat = 25
    fileprivate let personalHeadCellIdentifier = "PersonalHeadCellIdentifier"
    fileprivate let personalCellIdentifier = "PersonalCellIdentifier"
    fileprivate let titleScore:NSArray = [[LanguageHelper.getString(key: "contacter"),LanguageHelper.getString(key: "my_card"),LanguageHelper.getString(key: "friends_business_card"),LanguageHelper.getString(key: "setting")],[LanguageHelper.getString(key: "feedback"),LanguageHelper.getString(key: "about_us")]]
    fileprivate let imageScore: NSArray = [["ic_personal_contacts","ic_personal_setting","mine_businessCard","mine_friendsBusinessCard"],["ic_personal_feedback","ic_personal_aboutwe"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarBgAlpha = "0"
        self.view.addSubview(tableView)
        tableView.addSubview(footView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        if (UserDefaults.standard.object(forKey: "height") != nil){
            height = UserDefaults.standard.object(forKey: "height") as! CGFloat
        }
        return indexPath.section == 0 ? headHeight : height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? footHeight : section == 2 ? 0 : footHeight - 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: footHeight))
        view.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: personalHeadCellIdentifier, for: indexPath) as! PersonalHeadCell
            cell.selectionStyle = .none
            cell.manageWalletBlock = { (button:UIButton) in
                let vc = button.tag == 1 ? ManageWalletsVC() : TransactionRecordVC()
                self.pushNextViewController(vc, true)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: personalCellIdentifier, for: indexPath) as! PersonalCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
            let titleArray:NSArray = titleScore[indexPath.section - 1] as! NSArray
            let iconArray:NSArray = imageScore[indexPath.section - 1] as! NSArray
            let cellTag = indexPath.section == 1 ? self.cellTag : 4 + self.cellTag
            cell.setList(titleArray, iconArray ,cellTag)
            cell.personalCallBackBlock = { (sender:UIButton) in
                
                print(sender.tag)
                switch sender.tag - self.cellTag{
                case 0:
                    
                    self.pushNextViewController(ContactsVC(), true)
                    
                    break
           
                    
                case 1:
                    
                    self.pushNextViewController(MineBusinessCardVC(), true)
                    
                    break
                    
                case 2:
                    
                    self.pushNextViewController(FriendBusinessCardVC(), true)
                    
                    
                    break
                    
                case 3:
                    
                    self.pushNextViewController(SystemSettingsVC(), true)
                    
                    break
                    
                case 4:
                    
                    self.pushNextViewController(OpinionVC(), true)
                    
                    break
                    
                case 5:
                    
                    self.pushNextViewController(AboutWeVC(), true)
                    
                    break
                    
                default:
                    break
                }
            }
            return cell
        }
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: -64 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PersonalHeadCell", bundle: nil),forCellReuseIdentifier: self.personalHeadCellIdentifier)
        tableView.register(PersonalCell.self, forCellReuseIdentifier:self.personalCellIdentifier)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 243, green: 247, blue: 248, alpha: 1)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var footView:UIView = {
       let view = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - YMAKE(45) - 44 - 20, width: SCREEN_WIDTH, height: YMAKE(45)))
       let button = UIButton(frame: CGRect(x: 20, y: 0, width: SCREEN_WIDTH - 40, height: YMAKE(45)))
       button.setTitle(LanguageHelper.getString(key: "logut_out"), for: .normal)
       button.backgroundColor = R_UIThemeColor
       button.setTitleColor(UIColor.white, for: .normal)
       button.addTarget(self, action: #selector(PersonalVC.loginOutHandle), for: .touchUpInside)
       button.layer.cornerRadius = 5
       view.addSubview(button)
       return view
    }()
    
    func loginOutHandle(){
        //8.0以上
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title:LanguageHelper.getString(key: "prompt"),message:LanguageHelper.getString(key: "Are_you_sure_you_want_to_quit"),preferredStyle:UIAlertControllerStyle.alert)
            let cancelAction=UIAlertAction(title: LanguageHelper.getString(key: "version_cancel"), style: UIAlertActionStyle.default) { (alert) in
                
            }
            let okAction=UIAlertAction(title: LanguageHelper.getString(key: "confirm"), style: UIAlertActionStyle.default) { (alert) in
                LoginVC.switchRootVCToLoginVC()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        //8.0以下
        }else{
            let alertView = UIAlertView()
            alertView.title = LanguageHelper.getString(key: "prompt")
            alertView.message = LanguageHelper.getString(key: "Are_you_sure_you_want_to_quit")
            alertView.addButton(withTitle: LanguageHelper.getString(key: "version_cancel"))
            alertView.addButton(withTitle: LanguageHelper.getString(key: "confirm"))
            alertView.cancelButtonIndex=0
            alertView.delegate=self;
            alertView.show()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if(buttonIndex==alertView.cancelButtonIndex){
        }
        else
        {
            LoginVC.switchRootVCToLoginVC()
        }
    }
    
}
