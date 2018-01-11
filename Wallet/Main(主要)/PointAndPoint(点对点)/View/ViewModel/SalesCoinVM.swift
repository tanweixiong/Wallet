//
//  SalesCoinVM.swift
//  Wallet
//
//  Created by tam on 2017/10/9.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

enum LoadState {
    case success
    case failure(errorMessage: String)
}

class SalesCoinVM: BaseViewModel {
    
    var data: [SalesCoinModel] = []
    func loadDataWithHandler(_ handler: @escaping (_ loadState: LoadState) -> () ) {
            handler(.success)
        self.data = [SalesCoinModel()]
//        let parameters = ["":""]
//        NetWorkTool.request(.get, URLString: ConstAPI.kAPIMyWallet, parameters: parameters, showIndicator: true, success: { (json) in
//            
//            
//        }) { (error) in
//            
//        }
        
    }

}

class BuyCointVM: BaseViewModel {
    
    lazy var data: BuyCoinModel = BuyCoinModel()
    
    func loadDataWithHandler(_ handler: @escaping (_ loadState: LoadState) -> () ) {
        handler(.success)
        
        self.data = BuyCoinModel()
        //        let parameters = ["":""]
        //        NetWorkTool.request(.get, URLString: ConstAPI.kAPIMyWallet, parameters: parameters, showIndicator: true, success: { (json) in
        //
        //
        //        }) { (error) in
        //
        //        }
        
    }
    
    class purchaseListVM: BaseViewModel {
        
    }
    
}
