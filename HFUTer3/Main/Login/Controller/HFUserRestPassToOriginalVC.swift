//
//  HFUserRestPassToOriginalVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFUserRestPassToOriginalVC: HFFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "重置密码"
        initUI()
    }
    
    func initUI() {
        form +++
            Section("请使用教务系统/信息门户来验证身份，重置后社区账号密码为教务系统/信息门户密码")
            <<< SegmentedRow<String>("type") { $0.options = ["合肥信息门户", "合肥教学系统", "宣城教务系统"] }
            
            <<< TextRow("sid") {
                $0.title = "学号"
            }
            
            <<< TextRow("pwd") {
                $0.title = "密码"
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
            let type    = value["type"] as? String,
            let sid     = value["sid"] as? String,
            let pwd     = value["pwd"] as? String
            else {
                hud.showError("请填写完整")
                return
        }
        
        
        
        var params:HFRequestParam = [
            "sid":sid as AnyObject,
            "pwd":pwd as AnyObject,
            ]
        
        switch type {
        case "合肥信息门户":
            params["which"] = 0 as AnyObject?
        case "合肥教学系统":
            params["which"] = 1 as AnyObject?
        case "宣城教务系统":
            params["which"] = 2 as AnyObject?
        default:
            break
        }
        
        fire(params)
    }
    
    func fire(_ params:HFRequestParam) {
        hud.showLoading("正在重置")
        HFBaseRequest.fire("/api/resetPassword", method: HFBaseAPIRequestMethod.POST, params: params, succesBlock: { (request, resultDic) in
            hud.showMassage("重置成功")
            _ = self.navigationController?.popToRootViewController(animated: true)
        }) { (request, error) in
            hud.showError(error)
        }
    }
}
