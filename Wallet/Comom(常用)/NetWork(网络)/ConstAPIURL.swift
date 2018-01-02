//
//  ConstAPIURL.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/16.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

struct ConstAPI {
    static let kAPIMYBaseURL: String = "http://47.52.59.119:9099/"

    //正式
//    static let kAPIBaseURL: String = "http://192.168.10.101:9099/dhswallet/"
    static let kAPIBaseURL: String = "http://47.52.59.119:9099/dhswallet/"
    
//     static let kAPIBaseURL: String = "http://172.26.87.112:8080/"
    
    //开发
//    static let kAPIBaseURL: String = "http://10.0.0.42:80/dhs-wallet/dhswallet/"
    
    static let kAPIRegister = kAPIBaseURL + "user/add.do"   //注册接口
    static let kAPIEmailAdd = kAPIBaseURL + "user/emailAdd.do"   //注册接口
    
    static let kAPILogin = kAPIBaseURL + "user/login.do" //登录接口
    static let kAPIGetPersonalInfo = kAPIBaseURL + "user/get.do"   //获取个人信息接口
    static let kAPIRetrieveLoginPwd = kAPIBaseURL + "user/retrievePassword.do" //找回登录密码接口
    static let kAPIModifyLoginPwd = kAPIBaseURL + "user/editPassword.do" //修改登录密码接口
    static let kAPIRetrievePaymentPwd = kAPIBaseURL + "user/retrievePaymentPassword.do" //找回支付密码接口
    static let kAPIModifyPaymentPwd = kAPIBaseURL + "user/editPaymentPassword.do" //修改支付密码接口
    static let kAPIAddPaymentPwd = kAPIBaseURL + "user/addPaymentPassword.do" //设置支付密码接口
    
    static let kAPIGetAuthorizeCode = kAPIBaseURL + "user/dhsCode.do" //获取验证码接口
    static let kAPIUploadPhoto = kAPIBaseURL + "user/uploadPhoto.do" //上传图片接口
    
    static let kAPISendCode = kAPIBaseURL + "user/sendCode.do" //获取验证码接口

    static let kAPIAddContact = kAPIBaseURL + "communication/add.do" //添加通讯录接口
    static let kAPIDeleteContact = kAPIBaseURL + "communication/delete.do" //删除通讯录接口
    static let kAPIEditContact = kAPIBaseURL + "communication/edit.do" //修改通讯录接口
    static let kAPIGetContact = kAPIBaseURL + "communication/get.do" //查找通讯录接口
    
    static let kAPIUploadEdition = kAPIBaseURL + "edition/uploadEdition.do" //添加版本接口
    static let kAPIUpdateEdition = kAPIBaseURL + "edition/edit.do" //更新版本接口

    static let kAPIFeedback = kAPIBaseURL + "feedback/add.do" //意见反馈接口
    
    static let kAPIGetPhoneBillRechargeData = kAPIBaseURL + "JuheRecharge/getHuafei.do" //获取话费充值数据
    static let kAPIGetPhoneFlowRechargeData = kAPIBaseURL + "JuheRecharge/getLiuliang.do" //获取流量充值数据
    static let kAPIGetOilRechargeData = kAPIBaseURL + "JuheRecharge/getYouka.do" //获取油卡充值数据
    static let kAPIPhoneBillRecharge = kAPIBaseURL + "JuheRecharge/huafeiRecharge.do" //话费充值
    static let kAPIPhoneFlowRecharge = kAPIBaseURL + "JuheRecharge/liuliangRecharge.do" //流量充值
    static let kAPIOilRecharge = kAPIBaseURL + "JuheRecharge/youkaRecharge.do" //油卡充值
    
    static let kAPIGetVersionPatch = kAPIBaseURL + "versionPatch/getVersionPatch.do" //获取版本补丁
    
    static let kAPIGetMoney = kAPIBaseURL + "bill/getMoney.do" //主界面用户数据
    static let kAPIGetBill = kAPIBaseURL + "bill/getBill.do" //主界面用户数据
    static let kAPITransOrder = kAPIBaseURL + "bill/transOrder.do" //收付款

    //首页接口
    static let kAPIChangeNum = kAPIBaseURL + "wallet/changeNum.do" //首页钱包
    static let kAPIMyWallet = kAPIBaseURL + "wallet/mywallet.do" //首页钱包
    static let kAPIMyAnyWallet = kAPIBaseURL + "wallet/myAnyWallet.do" //首页钱包列表
    static let kAPIWalletList = kAPIBaseURL + "wallet/Walletlist.do" //首页钱包选择列表
    static let kAPIMyWalletState = kAPIBaseURL + "wallet/mywalletstate.do" //首页钱包选择列表
    
    //行情接口
    static let kAPIMyMarket = kAPIBaseURL + "coin/mymarket.do"
    static let kAPIMarketList = kAPIBaseURL + "wallet/marketlist.do"
    static let KAPIMyMarketState = kAPIBaseURL + "wallet/mymarketstate.do"
    static let kAPIThemarket = kAPIBaseURL + "coin/themarket.do"
    
    //钱币列表
    static let kAPICoinlist = kAPIBaseURL + "coin/coinlist.do"
    
    //确认付款
    static let kAPITrans = kAPIBaseURL + "bill/trans.do"
    
    //联系人列表
    static let kAPIMycontacts = kAPIBaseURL + "contacts/mycontacts.do" //查询联系人
    static let kAPIMyAddContacts = kAPIBaseURL + "contacts/add.do" //增加联系人
    static let kAPIMyDeleteContacts = kAPIBaseURL + "contacts/delete.do" //删除联系人
    
    //交易列表
    static let kAPIChangerecordList = kAPIBaseURL + "changerecord/list.do" //交易记录
    
    //帮助反馈
    static let kAPIFeedsAdd = kAPIBaseURL + "feeds/add.do"
    
    //名片首页
    static let kAPIBusinessCard = kAPIBaseURL + "business/card.do"
    //名片列表
    static let kAPIBusinessMyCard = kAPIBaseURL + "business/myCard.do"
    //资讯首页
    static let kAPINews = kAPIBaseURL + "news/newslist.do"
    //增加名片
    static let kAPIBusinessAdd = kAPIBaseURL + "business/add.do"
    //上传名片头像
    static let kAPIBusinessUploadPhoto = kAPIBaseURL + "business/uploadPhoto2.do"
    //删除自己的名片
    static let kAPIBusinessDeleteMyCard = kAPIBaseURL + "business/deleteMyCard.do"
    //删除好友名片
    static let kAPIBusinessRelevanceDelete = kAPIBaseURL + "businessRelevance/delete.do"
    //好友名片列表
    static let kAPIFriendTheCardList = kAPIBaseURL + "businessRelevance/theCardList.do"
    //增加好友名片列表
    static let kAPIFriendAddCardList = kAPIBaseURL + "businessRelevance/add.do"
    //修改名片
    static let kAPIUpdateMyCard = kAPIBaseURL + "business/updateMyCard.do"
    //邮箱注册
    static let kAPIUserEmailAdd = kAPIBaseURL + "user/emailAdd.do"
    //邮箱获取验证码
    static let kAPIUserSendCode = kAPIBaseURL + "user/sendCode.do"
    //修改邮箱
    static let kAPIUpdatePasswordByEmail = kAPIBaseURL + "user/updatePasswordByEmail.do"
    //使用邮箱修改支付密码
    static let kAPIEmailFoundPayPassword = kAPIBaseURL + "user/emailFoundPayPassword.do"
    //获取钱包地址
    static let kAPIWalletTheWallet = kAPIBaseURL + "wallet/theWallet.do"
    //添加转账功能
    static let kAPIBillTranSfer = kAPIBaseURL + "bill/TranSfer.do"
    
    
}

