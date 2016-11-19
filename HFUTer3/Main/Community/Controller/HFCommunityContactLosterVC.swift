//
//  HFCommunityContactLosterVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/6.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFCommunityContactLosterVC: HFFormViewController {
    
    var modelId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI() {
        form +++
            Section("如果发布人留下了联系方式，你可以直接联系TA；\n或者也可以使用此功能发送自己联系方式给对方，让对方联系自己。")
            <<< TextRow("phone") {
                $0.title = "手机号码"
            }
            
            <<< TextAreaRow("info") {
                $0.title = "联系信息"
                $0.value = "我见到了你的东西，请尽快联系我！"
        }
        
        +++ Section("")
            <<< ButtonRow() {
                $0.title = "发送"
                }.onCellSelection({ (cell, row) in
                    self.postLostAndFound()
                })
        
    }
    
    func postLostAndFound() {
        let value = form.values()
        guard
            let phone  = value["phone"] as? String,
            let info = value["info"] as? String
            else {
                hud.showError("请填写完整")
                return
        }
        
        let api = "/api/lostFound/sendMessage"
        
        let param : HFRequestParam = [
            "id"      : modelId as AnyObject,
            "phone"   : phone as AnyObject,
            "message" : info as AnyObject
        ]
        
        hud.showLoading("正在发送")
        HFBaseRequest.fire(api, method: HFBaseAPIRequestMethod.POST, params: param, succesBlock: { (request, resultDic) in
            hud.showMassage("发送成功")
            self.pop()
            }) { (request, error) in
                hud.showError(error)
        }
        
        AnalyseManager.ConnectLoster.record()
    }
}
