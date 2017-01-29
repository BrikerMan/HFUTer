//
//  HFImageView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import YYWebImage
import ZYCornerRadius

class HFImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate var cornerRadius: CGFloat = 0
    
    func cornet(_ radius: CGFloat) {
        zy_cornerRadiusAdvance(radius, rectCornerType: .allCorners)
        layer.cornerRadius = radius
        cornerRadius = radius * ScreenScale
    }
    
    var placeHolder = UIImage(named: "avatar")
    
    /**
     头像加载
     - parameter name: 头像名称
     */
    func loadAvatar(avatar name: String?){
        if let name = name {
            let urlString = APIBaseURL + "/res/head?head=" + name
            let url = URL(string: urlString)!
            self.loadImage(withURL: url)
        }
    }
    
    
    func loadCover(cover:String?) {
        self.placeHolder = UIImage(named: "hf_cover_placeholder")
        if let name = cover {
            //            let urlString = APIBaseURL + "/res/download?key=" + name
            let urlString = APIBaseURL + "/res/formatImage?key=" + name + "&format=imageView2/2/h/" + "160" + "/q/100"
            let url = URL(string: urlString)!
            self.loadImage(withURL: url)
        }
    }
    
    func loadCover(_ cover: String, finished:((_ image: UIImage?)->Void)? = nil) {
        let urlString = APIBaseURL + "/res/formatImage?key=" + cover
        if let url = URL(string: urlString) {
//            let target = CGSize(width: self.size.width * ScreenScale,
//                                height: self.size.height * ScreenScale)
            self.yy_setImage(with: url,
                             placeholder: placeHolder,
                             options: [.progressiveBlur, .showNetworkActivity],
                             progress: nil,
                             transform: { (image, url) -> UIImage? in
                                return image.yy_image(byRoundCornerRadius: self.cornerRadius)
//                                var image = image.yy_imageByResize(to: target,
//                                                                   contentMode: UIViewContentMode.scaleAspectFill)
//                                image = image?.yy_image(byRoundCornerRadius: self.cornerRadius)
//                                return image
            }) { (image, url, cacheType, stage, error) in
                finished?(image)
            }
        }
    }
    /**
     基本的图片加载方法
     - parameter url: 图片链接
     */
    func loadImage(withURL url:URL, successBlock:(()->Void)? = nil) {
        let target = CGSize(width: self.size.width * ScreenScale,
                            height: self.size.height * ScreenScale)
        self.yy_setImage(with: url,
                         placeholder: placeHolder,
                         options: [.progressiveBlur, .showNetworkActivity],
                         progress: nil,
                         transform: { (image, url) -> UIImage? in
                            var image = image.yy_imageByResize(to: target,
                                                               contentMode: UIViewContentMode.scaleAspectFill)
                            image = image?.yy_image(byRoundCornerRadius: self.cornerRadius)
                            return image
        }) { (image, url, cacheType, stage, error) in
            successBlock?()
        }
    }
    
    fileprivate func setup() {
        clipsToBounds = true
        contentMode   = UIViewContentMode.scaleAspectFill
//        backgroundColor = HFTheme.BlackAreaColor
    }
}
