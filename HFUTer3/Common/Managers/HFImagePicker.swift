//
//  HFImagePicker.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/29.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit
import RSKImageCropper

protocol HFImagePickerDelegate: class {
    func imagePickerDidGetCroppedImage(image: UIImage)
    func imagePickerDidCancel()
}

class HFImagePicker: NSObject {
    override init() {
        super.init()
    }
    
    let OfferCoverMinWidth  = CGFloat(200)
    let OfferCoverMinHeight = CGFloat(200)
    
    weak var delegate: HFImagePickerDelegate?
    
    weak var vc: UIViewController?
    
    func showActionSheet(vc: UIViewController) {
        self.vc = vc
        
        let alertController = UIAlertController()
        let action0 = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                picker.sourceType = .photoLibrary
            }
            vc.present(picker, animated: true, completion: nil)
        }
        
        let action1 = UIAlertAction(title: "相册", style: UIAlertActionStyle.default) { (action) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            vc.present(picker, animated: true, completion: nil)
        }
        
        let action2 = UIAlertAction(title: "取消", style: UIAlertActionStyle.destructive) { (action) in
            
        }
        
        alertController.addAction(action0)
        alertController.addAction(action1)
        alertController.addAction(action2)
        
        vc.present(alertController, animated: true, completion: nil)
    }
}


extension HFImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let copper = RSKImageCropViewController(image: pickedImage, cropMode: RSKImageCropMode.custom)
            copper.delegate = self
            copper.cropMode = .square
            
            copper.hidesBottomBarWhenPushed = true
            copper.setMinOutputSize(CGSize(width: OfferCoverMinWidth, height: OfferCoverMinHeight))
            copper.cancelButton.snp.updateConstraints({ (make) in
                make.width.equalTo(60)
            })
            copper.chooseButton.snp.updateConstraints({ (make) in
                make.width.equalTo(60)
            })
            copper.moveAndScaleLabel.text = ""
            copper.chooseButton.setTitle("截剪", for: UIControlState.normal)
            copper.cancelButton.setTitle("取消", for: UIControlState.normal)
            vc?.navigationController?.pushViewController(copper, animated: false)
            
            picker.dismissVC(completion: { })
        }
    }
}

extension HFImagePicker: RSKImageCropViewControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        vc?.popVC()
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        delegate?.imagePickerDidGetCroppedImage(image: croppedImage)
        vc?.popVC()
    }
}
