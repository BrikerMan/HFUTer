//
//  HFUserRegisterVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFUserRegisterVC: HFBaseViewController {
    
    // MARK: - StoryBoard Outlet
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loginTypeSegment: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navTitle = "注册"
    }
    
    
    // MARK: - Event Response
    @IBAction func onRegisterButtonPressed(_ sender: AnyObject) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            hud.showError("请输入账号和密码")
        } else {
            let reqeust = HFLoginRegisterRequest()
            reqeust.callback = self
//            reqeust.startLogin(withUsername:usernameTextField.text!, password: passwordTextField.text!)
            reqeust.startRegister(withUsername: usernameTextField.text!, password: passwordTextField.text!, type: loginTypeSegment.selectedSegmentIndex)
        }
    }
    
    // MARK: - Init UI
    fileprivate func setupUI() {
        shouldHideKeybardWhenTap = true
    }
    
}

// MARK: - HFBaseAPIManagerCallBack
extension HFUserRegisterVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        hud.showMassage("注册成功")
        performSegue(withIdentifier: PushRegisterSetEmailSegue, sender: nil)
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}
