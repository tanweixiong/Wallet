//
//  WalletOCTools.m
//  Wallet
//
//  Created by tam on 2017/10/24.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import "WalletOCTools.h"

@implementation WalletOCTools

+(NSDictionary *)getDictionaryFromJSONString:(NSString *)jsonStr{
    NSData * getJsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];
    return  getDict;
}

+(NSString *)getJSONStringFromDictionary:(id)testDict{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:testDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

//- (NSData *)toJSONData:(id)theData{
//    
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    
//    if ([jsonData length] > 0 && error == nil){
//        return jsonData;
//    }else{
//        return nil;
//    }
//}

//func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
//    
//    let jsonData:Data = jsonString.data(using: .utf8)!
//    
//    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
//    if dict != nil {
//        return dict as! NSDictionary
//    }
//    return NSDictionary()
//    
//    
//}
//
//func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
//    if (!JSONSerialization.isValidJSONObject(dictionary)) {
//        print("无法解析出JSONString")
//        return ""
//    }
//    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
//    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
//    return JSONString! as String
//    
//}

@end
