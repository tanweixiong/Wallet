//
//  WalletOCTools.h
//  Wallet
//
//  Created by tam on 2017/10/24.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WalletOCTools : NSObject
+(UIViewController *)getCurrentVC;
+(NSDictionary *)getDictionaryFromJSONString:(NSString *)jsonStr;
+(NSString *)getJSONStringFromDictionary:(id)testDict;
+(NSString *)getZZwithString:(NSString *)string;
@end
