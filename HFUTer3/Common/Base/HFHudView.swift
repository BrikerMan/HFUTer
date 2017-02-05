//
//  HFHudView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import WSProgressHUD
import SVProgressHUD
import YYText

let Hud = HFHudView.shared

class HFHudView {
    
    static let shared = HFHudView()
    
    var progressInfo = ""
    
    var progressView = HFHudBackView()
    
    fileprivate var progressInfoShowing = false
    fileprivate typealias hud = WSProgressHUD
    
    init() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
    }
    
    func showMassage(_ massage:String) {
        SVProgressHUD.dismiss()
        hud.showShimmeringString(massage)
        delay(seconds: 2) { () -> () in
            hud.dismiss()
        }
    }
    
    func showLoading(_ massage:String){
        SVProgressHUD.show(withStatus: massage)
    }
    
    func showLoadingWithMask(_ massage:String) {
        SVProgressHUD.dismiss()
        hud.showShimmeringString(massage, maskType: WSProgressHUDMaskType.black)
    }
    
    func showError(_ massage:String?) {
        SVProgressHUD.dismiss()
        hud.showShimmeringString(massage ?? "未知错误")
        delay(seconds: 2) { () -> () in
            hud.dismiss()
        }
    }
    
    func dismiss() {
        SVProgressHUD.dismiss()
        hud.dismiss()
    }
    
    func showPregress(_ add: String) {
        if !progressInfoShowing {
            let window = UIApplication.shared.keyWindow!
            window.addSubview(progressView)
            progressView.snp.makeConstraints {
                $0.left.equalTo(window.snp.left)
                $0.bottom.equalTo(window.snp.bottom).offset(-50)
            }
            progressInfoShowing = true
        }
        progressInfo =  progressInfo + "\n" + add 
        progressView.update(progressInfo)
    }
    
    func hideProgress() {
        progressView.removeFromSuperview()
        progressInfoShowing = false
    }
}

class HFHudBackView: UIView {
    var label = YYLabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)        
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
            $0.top.equalTo(self).offset(8)
            $0.bottom.equalTo(self).offset(-8)
            $0.width.equalTo(ScreenWidth - 100)
            $0.height.equalTo(20)
        }
    }
    
    func update(_ info: String) {
        let attText = NSMutableAttributedString(string: info, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 13),
            NSForegroundColorAttributeName: UIColor.white
            ])
        
        let size = CGSize(width: ScreenWidth - 100, height: CGFloat.greatestFiniteMagnitude)
        
        let mod = YYTextLinePositionSimpleModifier()
        mod.fixedLineHeight = 16
        
        let container = YYTextContainer(size: size)
        container.linePositionModifier = mod
        
        let layout = YYTextLayout(container: container, text: attText)!
        
        label.textLayout = layout
        label.snp.updateConstraints {
            $0.height.equalTo(layout.textBoundingSize.height)
        }
        layoutIfNeeded()
    }
}
