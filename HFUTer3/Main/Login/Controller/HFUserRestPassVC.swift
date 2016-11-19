//
//  HFUserRestPassVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFUserRestPassVC: HFFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        navTitle = "重置密码"
    }
    
    func initUI() {
        form +++
            Section("")
            <<< ButtonRow("使用教务系统/信息门户密码重置") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                    let vc = HFUserRestPassToOriginalVC()
                    return vc
                    }, onDismiss: { vc in vc.dismiss(animated: true, completion: nil) })
            }
            
            <<< ButtonRow("使用绑定邮箱重置") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                    let vc = HFUserRestPassByEmailVC()
                    return vc
                    }, onDismiss: { vc in vc.dismiss(animated: true, completion: nil) })
        }
    }
    
    
}
