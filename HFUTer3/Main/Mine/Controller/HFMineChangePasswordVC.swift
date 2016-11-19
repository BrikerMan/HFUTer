//
//  HFMineChangePasswordVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/8/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFMineChangePasswordVC: HFFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         setupForm()
        navTitle = "修改密码"
    }

    
    func setupForm() {
        form +++
            Section("")
            
            <<< PasswordRow("oldPass") {
                $0.title = "旧密码"
            }
            
            <<< PasswordRow("new1") {
                $0.title = "新密码"
            }
            
            <<< PasswordRow("new2") {
                $0.title = "验证"
            }
            
            +++ Section("")
            <<< ButtonRow() { row in
                row.title = "修改密码"
                }  .onCellSelection({ (cell, row) in
                    self.conferm()
                })
    }
    
    
    func conferm() {
        if let oldPas = form.values()["oldPass"] as? String, !oldPas.isBlank,
        let new1 = form.values()["new1"] as? String, !new1.isBlank,
        let new2 = form.values()["new2"] as? String, !new2.isBlank {
            if new1 == new2 {
                if new1.characters.count < 6 {
                    hud.showError("密码太短")
                    return
                }
                changePassRequest(oldPas, new: new1)
            } else {
                hud.showError("两次输入不一致")
                return
            }
        } else {
            hud.showError("请输入完整")
            return
        }

    }
    
    func changePassRequest(_ old:String, new:String) {
        
        let params: HFRequestParam = [
            "old_pwd": old.md5() as AnyObject,
            "new_pwd": new.md5() as AnyObject
        ]
        
        hud.showLoading("正在修改")
        HFBaseRequest.fire("/api/user/alertPassword", method: HFBaseAPIRequestMethod.POST, params: params, succesBlock: { (request, resultDic) in
            hud.showMassage("修改成功")
            DataEnv.user!.password = new
            DataEnv.user!.save()
            self.pop()
        }) { (request, error) in
            hud.showError(error)
        }
    }
}
