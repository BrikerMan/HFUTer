//
//  HFCommonWriteVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFCommonWriteVC: HFFormViewController {
    
    var publishBlock:((_ text:String , _ anonymous: Bool)->())?
    var cancelBlock:(()->())?
    
    var at:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let at = at {
            navTitle = "@\(at)"
        } else {
            navTitle = "发表评论"
        }
        hideNavLeftButton = true
        initUI()
    }
    
    fileprivate func initUI() {
        form +++ Section("") { section in
            section.header?.height = { 20 }
            section.footer?.height = { 0.01 }
            }
            <<< TextAreaRow("content") {
                $0.placeholder = "请输入"
            }
            
            <<< SwitchRow("anonymous"){
                $0.title = "匿名发布"
                $0.value = false
            }
            
            +++ Section("") { section in
                section.header?.height = { 0.01 }
                section.footer?.height = { 0.01 }
            }
            
            <<< ButtonRow("conferm") { row in
                row.title = "发布"
                row.disabled = "$content = ''"
                }  .onCellSelection({ (cell, row) in
                    self.publishButtonPressed()
                })
            
            +++ Section("") { section in
                section.header?.height = { 0.01 }
                section.footer?.height = { 0.01 }
            }
            
            <<< ButtonRow("cancel") { row in
                row.title = "取消"
                }  .onCellSelection({ (cell, row) in
                    self.cancelButtonPressed()
                })
    }
    
    func cancelButtonPressed() {
        cancelBlock?()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func publishButtonPressed() {
        if let content = form.values()["content"] as? String, !content.isBlank {
            let anonymous = form.values()["anonymous"] as? Bool ?? false
            publishBlock?(content,anonymous)
            self.dismiss(animated: true, completion: nil)
        } else {
            hud.showError("请输入内容")
        }
    }
    
}


class SectionHeader: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
