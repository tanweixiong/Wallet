//
//  ConstTools.m
//  DHSWallet
//
//  Created by tam on 2017/10/20.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

#import "ConstTools.h"
#define Symbol @"?"
#define Type @"type="
#define Amount @"amount="
#define Businesscard @"businesscard="
@implementation ConstTools

+(NSArray *)getCodeMessage:(NSString *)codeString codeKey:(NSString *)codeKey{
    NSString *address = @"";
    NSString *amount = @"";
    NSString *type = @"";
    NSString *businesscard = @"";
    NSString *newCodeKey = [NSString stringWithFormat:@"%@:",codeKey];
    //获取地址
    if([codeString rangeOfString:newCodeKey].location !=NSNotFound)//_roaldSearchText
    {
        NSRange startRange = [codeString rangeOfString:newCodeKey];
        
        NSInteger startIndex = startRange.location + newCodeKey.length;
        
        //获取标点的Range
        NSRange endRange = [codeString rangeOfString:Symbol];
        //获取标点的下标
        NSInteger endIndex = endRange.location + Symbol.length;
        
        address = [codeString substringWithRange:NSMakeRange(startIndex, endIndex - startIndex - Symbol.length)];
        
        NSString *str = [codeString substringFromIndex:startIndex + address.length + Symbol.length];
        
        NSArray* array = [str componentsSeparatedByString:@"&"];
        
        
        for (int i = 0; i<array.count; i++) {
            NSString *str = array[i];
            
            if([str rangeOfString:Amount].location !=NSNotFound){
                
                amount = [str stringByReplacingOccurrencesOfString:Amount withString:@""];
            }
            
            if([str rangeOfString:Type].location !=NSNotFound){
                
                type = [str stringByReplacingOccurrencesOfString:Type withString:@""];
            }
            
            if([str rangeOfString:Businesscard].location !=NSNotFound){
                
                businesscard = [str stringByReplacingOccurrencesOfString:Businesscard withString:@""];
            }
            
        }
    }
    return @[address,amount,type,businesscard];
}

@end
