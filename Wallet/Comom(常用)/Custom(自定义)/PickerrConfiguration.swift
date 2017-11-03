//
//  PickerrConfiguration.swift
//  Wallet
//
//  Created by tam on 2017/11/3.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class PickerrConfiguration: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    class func uploadpictures(_ VC:UIViewController){
        let alertAction = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alertAction.addAction(UIAlertAction.init(title: "相机", style: .default, handler: { (alertCamera) in
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = VC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            pickerVC.sourceType = .camera
            pickerVC.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                VC.present(pickerVC, animated: true, completion: nil)
            } else {
                //                SVProgressHUD .show(withStatus: "请允许访问相机")
            }
        }))
        alertAction.addAction(UIAlertAction.init(title: "相册", style: .default, handler: { (alertPhoto) in
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = VC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            pickerVC.sourceType = .photoLibrary
            pickerVC.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                VC.present(pickerVC, animated: true, completion: nil)
            }  else {
                //                SVProgressHUD .show(withStatus: "请允许访问相册")
            }
        }))
        alertAction.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (alertCancel) in
            
        }))
        VC.present(alertAction, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
}
