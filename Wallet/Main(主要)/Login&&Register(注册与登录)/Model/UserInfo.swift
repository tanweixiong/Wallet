//
//  UserInfo.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/22.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import MJExtension

class UserInfo: NSObject,NSCoding {
    var age:NSNumber = 0
    var count:NSNumber = 0
    var date:String = ""
    var flag:NSNumber = 0
    var grade:NSNumber = 0
    var id:NSNumber = 0
    var integral:NSNumber = 0
    var loginDate:String = ""
    var password:String = ""
    var payCount:NSNumber = 0
    var payDate:String = ""
    var payFlag:NSNumber = 0
    var paymentPassword:String = ""
    var phone:NSNumber = 0
    var photo:String = ""
    var sex:NSNumber = 0
    var state:NSNumber = 0
    var token:String = ""
    var userId:String = ""
    var username:String = ""
    var isLogin:NSNumber = 0
    var userphoto:String = ""
    
    
    //构造方法
    required init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    required override init() {
        super.init()
        age = 0
        count = 0
        date = ""
        flag = 0
        grade = 0
        id = 0
        integral = 0
        loginDate = ""
        password = ""
        payCount = 0
        payDate = ""
        payFlag = 0
        paymentPassword = ""
        phone = 0
        photo = ""
        sex = 0
        state = 0
        token = ""
        userId = ""
        username = ""
        isLogin = 0
        userphoto = ""
    }
    
//    从object解析回来
    required init(coder decoder: NSCoder) {
        self.age = decoder.decodeObject(forKey: "age") as? NSNumber ?? 0
        self.count = decoder.decodeObject(forKey: "count") as? NSNumber ?? 0
        self.date = decoder.decodeObject(forKey: "date") as? String ?? ""
        self.flag = decoder.decodeObject(forKey: "flag") as? NSNumber ?? 0
        self.grade = decoder.decodeObject(forKey: "grade") as? NSNumber ?? 0
        self.id = decoder.decodeObject(forKey: "id") as? NSNumber ?? 0
        self.integral = decoder.decodeObject(forKey: "integral") as? NSNumber ?? 0
        self.loginDate = decoder.decodeObject(forKey: "loginDate") as? String ?? ""
        self.password = decoder.decodeObject(forKey: "password") as? String ?? ""
        self.payCount = decoder.decodeObject(forKey: "payCount") as? NSNumber ?? 0
        self.payDate = decoder.decodeObject(forKey: "payDate") as? String ?? ""
        self.payFlag = decoder.decodeObject(forKey: "payFlag") as? NSNumber ?? 0
        self.paymentPassword = decoder.decodeObject(forKey: "paymentPassword") as? String ?? ""
        self.phone = decoder.decodeObject(forKey: "phone") as? NSNumber ?? 0
        self.photo = decoder.decodeObject(forKey: "photo") as? String ?? ""
        self.sex = decoder.decodeObject(forKey: "sex") as? NSNumber ?? 0
        self.state = decoder.decodeObject(forKey: "state") as? NSNumber ?? 0
        self.token = decoder.decodeObject(forKey: "token") as? String ?? ""
        self.userId = decoder.decodeObject(forKey: "userId") as? String ?? ""
        self.username = decoder.decodeObject(forKey: "username") as? String ?? ""
        self.isLogin = decoder.decodeObject(forKey: "isLogin") as? NSNumber ?? 0
        self.userphoto = decoder.decodeObject(forKey: "userphoto") as? String ?? ""
    }
    
    //编码成object
    func encode(with coder: NSCoder) {
        coder.encode(age, forKey:"age")
        coder.encode(count, forKey:"count")
        coder.encode(date, forKey:"date")
        coder.encode(flag, forKey:"flag")
        coder.encode(grade, forKey: "grade")
        coder.encode(id, forKey:"id")
        coder.encode(integral, forKey:"integral")
        coder.encode(loginDate, forKey:"loginDate")
        coder.encode(password, forKey:"password")
        coder.encode(payCount, forKey:"payCount")
        coder.encode(payDate, forKey:"payDate")
        coder.encode(payFlag, forKey:"payFlag")
        coder.encode(paymentPassword, forKey:"paymentPassword")
        coder.encode(phone, forKey:"phone")
        coder.encode(photo, forKey:"photo")
        coder.encode(sex, forKey:"sex")
        coder.encode(state, forKey:"state")
        coder.encode(token, forKey:"token")
        coder.encode(userId, forKey:"userId")
        coder.encode(username, forKey:"username")
        coder.encode(isLogin, forKey:"isLogin")
        coder.encode(userphoto, forKey:"userphoto")
    }
    
}






