//
//  HFUserLoginVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/15.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFUserLoginVC: HFBasicViewController {
    
    
    // MARK: - StoryBoard Outlet
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logoImageView: HFPlaceholdImageView!
    
    // MARK: - Data and Views
    fileprivate var loginRequest: HFLoginRequest!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        logoImageView.layer.cornerRadius = 5
        view.backgroundColor   = HFTheme.TintColor
      
        usernameTextField.tintColor = UIColor.white
        passwordTextField.tintColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Event Response
    @IBAction func onLoginButtonPressed(_ sender: AnyObject) {
        loginRequest = HFLoginRequest()
        loginRequest.callback = self
        loginRequest.startLogin(withUsername: usernameTextField.text!, password: passwordTextField.text!)
        hud.showLoading("正在登陆")
    }
    
    
    @IBAction func onRegisterButtonPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func onShowPassButtonPressed(_ sender: AnyObject) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func onUnableLoginButtonPressed(_ sender: AnyObject) {
        let vc = HFUserRestPassVC()
        self.push(vc)
    }
    
    @IBAction func onHelpButtonPressed(_ sender: AnyObject) {
        let vc = HFHelpInfoWebVC(nibName: "HFHelpInfoWebVC", bundle: nil)
        self.push(vc)
    }
    
    
    // MARK: - 初始化
    fileprivate func initUI() {
        shouldHideKeybardWhenTap = true
    }
}

// MARK: - 请求回调
extension HFUserLoginVC:HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        if let user = HFUserLoginViewModel().prepareModel(fromDictionary: manager.resultDic) {
            user.password = passwordTextField.text!
            DataEnv.user = user
            DataEnv.user?.save()
            DataEnv.isLogin = true
            hud.showMassage("登陆成功")
            NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.UserLogin.rawValue), object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showMassage(manager.errorInfo)
    }
}
