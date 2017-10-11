//
//  LanguageHelper.swift
//  Wallet
//
//  Created by tam on 2017/9/18.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PhotoBlock)(UIImage *image);

@interface LJXPhotoAlbum : NSObject

- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)Controller
                                   andWithBlock:(PhotoBlock)photoBlock;

@end
