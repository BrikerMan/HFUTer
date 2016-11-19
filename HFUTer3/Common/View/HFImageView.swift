//
//  HFImageView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import YYWebImage

class HFImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
    
    /**
     基本的图片加载方法
     - parameter url: 图片链接
     */
    func loadImage(withURL url:URL, successBlock:(()->Void)? = nil) {
        self.yy_setImage(with: url, placeholder: placeHolder, options: [YYWebImageOptions.progressiveBlur]) { (image, url, from, stafe, error) in
            successBlock?()
        }
    }
    
    fileprivate func setup() {
        clipsToBounds = true
        contentMode   = UIViewContentMode.scaleAspectFill
        backgroundColor = HFTheme.BlackAreaColor
    }
}
