//
//  HFUserRestPassByEmailVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFUserRestPassByEmailVC: HFFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "重置密码"
        initUI()
    }
    
    func initUI() {
        form +++
            Section("使用绑定邮箱重置密码，然后使用邮箱收到的连接重置密码")
            
            <<< TextRow("sid") {
                $0.title = "学号"
            }
            
            <<< TextRow("email") {
                $0.title = "Email"
        }

            
            +++ Section("")
            <<< ButtonRow() { row in
                row.title = "重置"
                }  .onCellSelection({ (cell, row) in
                    self.post()
                })
    }
    
    
    
    func post() {
        // check
        let value = form.values()
        guard
            let sid     = value["sid"] as? String,
            let email     = value["email"] as? String
            else {
                hud.showError("请填写完整")
                return
        }
        
        
        
        let params:HFRequestParam = [
            "sid":sid as AnyObject,
            "email":email as AnyObject,
            ]
        
        fire(params)
    }
    
    func fire(_ params:HFRequestParam) {
        hud.showLoading("正在重置")
        HFBaseRequest.fire("/api/user/applyResetPassword", method: HFBaseAPIRequestMethod.POST, params: params, succesBlock: { (request, resultDic) in
            hud.showMassage("邮件发送成功，请使用邮件中连接重置")
            self.navigationController?.popToRootViewController(animated: true)
        }) { (request, error) in
            hud.showError(error)
        }
    }
}
