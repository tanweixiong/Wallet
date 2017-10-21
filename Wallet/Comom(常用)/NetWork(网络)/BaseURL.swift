//
//  BaseURL.swift
//  Wallet
//
//  Created by tam on 2017/10/16.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

var cityName = "成都"
var myWeatherKey = "123456789"

public var baseURL: NSURL {
    let str: String = "https://api.weather.com/weather?"
    let queryItem1:NSURLQueryItem = NSURLQueryItem(name: "city", value: "啊接受得了")
    let queryItem2:NSURLQueryItem = NSURLQueryItem(name: "key", value: myWeatherKey)
    let urlCom = NSURLComponents(string: str)
    urlCom?.queryItems = [queryItem1 as URLQueryItem,queryItem2 as URLQueryItem]
    return (urlCom?.url!)! as NSURL
}
