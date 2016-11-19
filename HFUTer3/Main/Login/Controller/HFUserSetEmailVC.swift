//
//  HFUserSetEmailVCViewController.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFUserSetEmailVC: HFBaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        navTitle = "设置邮箱"
    }
    
    @IBAction func onSetUserEmailButtonPressed(_ sender: AnyObject) {
        let email = emailTextField.text!
        
        if email.isEmail {
            let request = HFUserInfoChangeRequest()
            request.callback = self
            request.updateEmail(email: email)
        } else {
            hud.showError("请输入有效邮箱地址")
        }
        
    }
    
    // MARK: - 初始化
    fileprivate func initUI() {
        shouldHideKeybardWhenTap = true
    }
    
}

// MARK: - HFBaseAPIManagerCallBack
extension HFUserSetEmailVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        hud.showMassage("设置成功")
        self.dismiss(animated: true, completion: nil)
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}
