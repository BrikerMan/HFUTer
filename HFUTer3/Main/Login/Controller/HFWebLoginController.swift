//
//  HFWebLoginController.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/13.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit

class HFWebLoginController: HFBaseViewController {
    
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: "http://my.hfut.edu.cn/")!)
        webView.loadRequest(request)
        setupUI()
    }
    
    func onHasLoginButtonPressed() {
        var req = URLRequest(url: URL(string: "http://bkjw.hfut.edu.cn/StuIndex.asp")!)
        req.httpMethod = "GET"
        HFBaseSession.fire(request: req, redirect: false) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 302 {
                print("验证成功")
            } else {
                print("验证失败了")
            }
        }
    }
    
    func setupUI() {
        
        navTitle = "网页登录"
        
//        let navBar = UIView()
//        navBar.backgroundColor = HFTheme.TintColor
//        
//        
//        
//        view.addSubview(navBar)
        view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(view.snp.top).offset(64)
        }
        
        
    }
    
}
