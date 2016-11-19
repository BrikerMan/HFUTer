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

class HFHudView {
    
    static let shared = HFHudView()
    
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
        
//        SVProgressHUD.showInfoWithStatus(massage ?? "未知错误")
//        delay(seconds: 2) { () -> () in
//            SVProgressHUD.dismiss()
//        }
    }
    
    func dismiss() {
        SVProgressHUD.dismiss()
        hud.dismiss()
    }
}
