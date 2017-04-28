//
//  HFMineRepostViewController.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/4.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka
import Pitaya

class HFMineRepostViewController: HFFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    
    func fire() {
        let text = form.values()["notes"] as? String ?? ""
        if text.isEmpty {
            Hud.showError("问题不能为空")
            return
        } else {
            Hud.showLoading()
            var log = ""
            do {
                let url = Logger.lastLogPath() ?? ""
                log = try String(contentsOfFile: url)
            } catch {
                
            }
            
            let json: JSON = [
                "text": (DataEnv.user?.sid ?? "") + " : " + text,
                "attachments":[
                    ["title":"log", "text": log]
                ]
            ]
            
            Pita.build(HTTPMethod: .POST, url: "https://hook.bearychat.com/=bw9VJ/incoming/4538e1f294076a134ce0b81596cfdedb")
                .setHTTPBodyRaw(json.formatJSON() ?? "", isJSON: true)
                .responseJSON({ (json, response ) in
                    Hud.dismiss()
                    self.pop()
                })
            
        }
    }
    
    func setup() {
        form +++ Section("提交问题和 log 可以帮助程序员快速定位问题并修复，后续进展请加内测qq群 117196247 咨询")
            
            <<< TextAreaRow("notes") {
                $0.placeholder = "请描述遇到的问题"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
            }
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "提交"
                }.onCellSelection({ (cell, row) in
                    self.fire()
                })
    }
}
