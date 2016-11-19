//
//  HFUserAvaterNickNameVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFUserAvaterNickNameVC: HFBaseViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var avatarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        navTitle = "设置头像昵称"
        // Do any additional setup after loading the view.
    }

    @IBAction func onSelectImageButtonPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func onRegisterButtonPressed(_ sender: AnyObject) {
    }
    
    
    @IBAction func onSkipButonPressed(_ sender: AnyObject) {
    
    }
    
    // MARK: - 初始化
    fileprivate func initUI() {
        shouldHideKeybardWhenTap = true
    }
    
}
