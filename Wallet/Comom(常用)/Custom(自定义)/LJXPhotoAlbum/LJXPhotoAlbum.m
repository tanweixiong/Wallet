//
//  LanguageHelper.swift
//  Wallet
//
//  Created by tam on 2017/9/18.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

#import "LJXPhotoAlbum.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ScreenF [UIScreen mainScreen].bounds
#define ScreenW ScreenF.size.width
#define ScreenH ScreenF.size.height
#define IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface LJXPhotoAlbum ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, copy) PhotoBlock photoBlock;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIViewController        *viewController;
@property(nonatomic,assign) BOOL isEnglish;
@end

@implementation LJXPhotoAlbum

- (instancetype)init {
    self = [super init];
    if (self) {
        _picker = [[UIImagePickerController alloc]init];
    }
    return self;
}

- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)viewController andWithBlock:(PhotoBlock)photoBlock {
    self.photoBlock = photoBlock;
    self.viewController = viewController;
    if (IOS8) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * language= [userDefaults objectForKey:@"Reality_Languages"];
        if ([language isEqualToString:@"en"]){
            _isEnglish = YES;
        }else{
            _isEnglish = NO;
        }
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_isEnglish ? @"image" : @"图片" message: _isEnglish ? @"select" : @"选择" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:_isEnglish ? @"Album" : @"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getAlertActionType:1];
        }];
        UIAlertAction *cemeraAction = [UIAlertAction actionWithTitle:_isEnglish ? @"camera" : @"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getAlertActionType:2];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:_isEnglish ? @"cancel" : @"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self getAlertActionType:0];
        }];
        [alertController addAction:photoAlbumAction];
        [alertController addAction:cancleAction];
        if ([self imagePickerControlerIsAvailabelToCamera]) {
            [alertController addAction:cemeraAction];
        }
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet;
        if([self imagePickerControlerIsAvailabelToCamera]){
            actionSheet  = [[UIActionSheet alloc] initWithTitle:_isEnglish ? @"Select the image" : @"选择图像" delegate:self cancelButtonTitle:_isEnglish ? @"cancel" : @"取消" destructiveButtonTitle:nil otherButtonTitles:_isEnglish ? @"Take pictures" : @"拍照", _isEnglish ? @"Select from album" : @"从相册选择", nil];
        }else{
            actionSheet = [[UIActionSheet alloc] initWithTitle:_isEnglish ? @"Select the image" : @"选择图像" delegate:self cancelButtonTitle:_isEnglish ? @"cancel" : @"取消" destructiveButtonTitle:nil otherButtonTitles:_isEnglish ? @"Select from album" : @"从相册选择", nil];
        }
        [actionSheet showInView:self.viewController.view];
    }
    
    
}

- (void)getAlertActionType:(NSInteger)type {
    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (type) {
        case 1:
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
        case 2:
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
        case 0:
        {
            return;
        }
            break;
            
        default:
            break;
    }
    [self creatUIImagePickerControllerWithAlertActionType:sourceType];
    
}


#pragma mark - ActionSheet Delegte
- (void)actionSheet:(UIActionSheet *)actionSheetn clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([self imagePickerControlerIsAvailabelToCamera]){
        switch (buttonIndex){
            case 0:
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
                break;
            case 1:
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
                break;
            case 2:
                return;
        }
    } else {
        switch (buttonIndex) {
            case 0:
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
                break;
                
            default:
                break;
        }
    }
    [self creatUIImagePickerControllerWithAlertActionType:sourceType];
}


#pragma mark -  创建ImagePickerController
- (void)creatUIImagePickerControllerWithAlertActionType:(NSInteger)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * language= [userDefaults objectForKey:@"Reality_Languages"];
    if ([language isEqualToString:@"en"]){
        _isEnglish = YES;
    }else{
        _isEnglish = NO;
    }
    NSInteger sourceType = type;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![self AVAuthorizationStatusIsGranted]) {
            if (IOS8) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_isEnglish ? @"The camera is not authorized" : @"相机未授权" message:_isEnglish ? @"Please go to the settings to modify" : @"请到设置中修改" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:_isEnglish ? @"determine" : @"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    return;
                }];
                [alertController addAction:comfirmAction];
                [self.viewController presentViewController:alertController animated:YES completion:nil];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_isEnglish ? @"The camera is not authorized" : @"相机未授权" message:_isEnglish ? @"Please go to the settings to modify" : @"请到设置中修改" delegate:nil cancelButtonTitle:_isEnglish ? @"determine" : @"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
    }
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    self.picker.sourceType = sourceType;
    [self.viewController presentViewController:self.picker animated:YES completion:nil];
}


// 判断硬件是否支持拍照
- (BOOL)imagePickerControlerIsAvailabelToCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 照机授权判断
- (BOOL)AVAuthorizationStatusIsGranted  {
    __block BOOL isGranted = NO;
    //判断是否授权相机
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (authStatus) {
        case 0: { //第一次使用，则会弹出是否打开权限
            [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                //授权成功
                if (granted) {
                    isGranted = YES;
                }
                else{
                    isGranted = NO;
                }
            }];
        }
            break;
        case 1:{
            //还未授权
            isGranted = NO;
        }
            break;
        case 2:{
            //主动拒绝授权
            isGranted = NO;
        }
            break;
        case 3: {
            //已授权
            isGranted = YES;
        }
            break;
            
        default:
            break;
    }
    return isGranted;
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取编辑后的图片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    NSLog(@"DELEGATE %@",image);
    if (self.photoBlock) {
        self.photoBlock(image);
    }
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择照片:
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消图片选择");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
