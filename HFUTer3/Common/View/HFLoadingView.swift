//
//  HFLooadingView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/17.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

// 用传统方法初始化加载吧，少点坑

@IBDesignable
class HFLoadingView: UIView {
    
    var indector:NVActivityIndicatorView?
    var indectorWith: CGFloat = 40
    var style = NVActivityIndicatorType.ballScaleMultiple
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    func add(to: UIView) {
        to.addSubview(self)
        self.snp.makeConstraints {
            $0.edges.equalTo(to).inset(UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        }
    }
    
    func show() {
        self.superview?.bringSubview(toFront: self)
        self.alpha = 1.0
    }
    
    // 隐藏动画
    func hide() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { (finished) -> Void in
                self.removeFromSuperview()
        }) 
    }
    
    fileprivate func setupView() {
        self.backgroundColor = HFTheme.BlackAreaColor
        
        // 初始化，此时x，y并不重要，因为要用Autolayout
        let rect = CGRect(x: 0, y: 0, width: indectorWith, height: indectorWith)
        indector = NVActivityIndicatorView(frame: rect, type: style, color: HFTheme.TintColor, padding: 0)
        self.addSubview(indector!)
        
        //使用AutoLayout更新位置，居中显示
        indector!.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        indector?.startAnimating()
        
        self.alpha = 0.0
    }
}
