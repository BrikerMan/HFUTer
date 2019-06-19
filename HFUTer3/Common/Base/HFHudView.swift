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
let hud             = HFHudView.shared

class HFHudView: NSObject {
    
    static let shared = HFHudView()
    
    var dismissTimeInterval = 4.0
    
    fileprivate typealias hud = WSProgressHUD
    
    func showMassage(_ massage:String) {
        runOnMainThread {
            hud.showShimmeringString(massage)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
            self.perform(#selector(self.dismiss), with: nil, afterDelay: self.dismissTimeInterval)
        }
    }
    
    func showLoading(_ massage:String = "正在处理 ...", masked: Bool = false){
        runOnMainThread {
            if masked {
                hud.show(withStatus: massage, maskType: .gradient)
            } else {
                hud.show(withStatus: massage)
            }
        }
    }
    
    func showLoadingWithMask(_ massage:String) {
        runOnMainThread {
            hud.showShimmeringString(massage, maskType: WSProgressHUDMaskType.black)
        }
        
    }
    
    func showError(_ massage:String?) {
        runOnMainThread {
            hud.showShimmeringString(massage ?? "未知错误")
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
            self.perform(#selector(self.dismiss), with: nil, afterDelay: self.dismissTimeInterval)
        }
    }
    
    @objc func dismiss() {
        runOnMainThread {
            hud.dismiss()
        }
    }
    
    func showToastError(_ massage:String?) {
        runOnMainThread {
            HFToast.debugInfo(massage ?? "未知错误")
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
            self.perform(#selector(self.dismiss), with: nil, afterDelay: self.dismissTimeInterval)
        }
        
    }
    
    @objc func toastDismiss() {
        runOnMainThread {
            HFToast.toast?.cancel()
        }
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
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13),
            NSAttributedStringKey.foregroundColor: UIColor.white
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
