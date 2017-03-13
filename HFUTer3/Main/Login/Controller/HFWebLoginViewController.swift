//
//  HFWebLoginViewController.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/13.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFWebLoginViewController: HFBasicViewController, XibBasedController {
    
    var finishedBlock: ((_ succeed: Bool) -> Void)?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: URL(string: "http://my.hfut.edu.cn/")!)
        webView.loadRequest(request)
        webView.delegate = self
        Hud.showLoading("正在加载", masked: false)
        view.backgroundColor = HFTheme.TintColor
        
    }
    
    @IBAction func onCancelButtonPressed(_ sender: Any) {
        finishedBlock?(false)
        self.dismissVC(completion: nil)
    }
    
    
    @IBAction func onDoneButtonPressed(_ sender: Any) {
        Hud.showLoading("正在验证", masked: true)
        var req = URLRequest(url: URL(string: "http://bkjw.hfut.edu.cn/StuIndex.asp")!)
        req.httpMethod = "GET"
        HFBaseSession.fire(request: req, redirect: false) { (data, response, error) in
            Hud.dismiss()
            if let response = response as? HTTPURLResponse, response.statusCode == 302 {
                self.finishedBlock?(true)
                self.dismissVC(completion: nil)
            } else {
                Hud.showError("验证失败")
            }
        }
    }
    
    
    
    
    @IBAction func onAutoFillButtonPressed(_ sender: Any) {
        let alertController = HFTextFieldAlertController(title: "请输入门户密码密码", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.delegate = self
        alertController.type = HFTextFieldAlertType.email
        alertController.addConrimButtonAndTextField(confermTitle: "确认")
        alertController.textFields?.first?.text = PlistManager.userDataPlist.getValues()?["cachedMhPass"] as? String
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    fileprivate func autoFill() {
        // fill data
        let savedUsername = DataEnv.user?.sid ?? ""
        let savedPassword = PlistManager.userDataPlist.getValues()?["cachedMhPass"] as? String ?? ""
        
        let fillForm = String(format: "document.getElementById('username').value = '\(savedUsername)';document.getElementById('password').value = '\(savedPassword)';")
        webView.stringByEvaluatingJavaScript(from: fillForm)
        
        
        
        
    }
}

extension HFWebLoginViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Hud.dismiss()
        autoFill()
        let updateUI = "var imgs=document.getElementsByTagName('img');for(var i=0;i<imgs.length;i++){if(imgs[i].id!='captchaImg'){imgs[i].style.display='none';imgs[i].style.width=0}console.log(imgs[i].id)}var tables=document.getElementsByTagName('table');for(var i=0;i<tables.length;i++){tables[i].style.width='auto'}var other=document.getElementsByTagName('place2');for(var i=0;i<other.length;i++){other[i].style.display='none'};"
        webView.stringByEvaluatingJavaScript(from: updateUI)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print(request)
        return true
    }
}


extension HFWebLoginViewController: HFTextFieldAlertControllerDelegate {
    func alertControllerDidConrim( _ alertController: HFTextFieldAlertController, withText text:String) {
        PlistManager.userDataPlist.saveValues(["cachedMhPass":text])
        autoFill()
    }
}
