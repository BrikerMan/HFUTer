//
//  HFCommunityPostLoveWallVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/1.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFCommunityPostLoveWallVC: HFFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "发布表白"
        initUI()
    }
    
    fileprivate func initUI() {
        form +++ Section("")
            
            <<< TextAreaRow("content") {
                $0.placeholder = "请输入表白内容"
            }
            
            +++ Section()
            // TODO: 图片选择
//            <<< ImageRow("cover") {
//                $0.title = "封面照片（可选）"
//            }
            <<< SwitchRow("anonymous"){
                $0.title = "匿名发布"
                $0.value = false
            }
            
            +++ Section()
            
            <<< ButtonRow() { row in
                row.title = "发布"
                }  .onCellSelection({ (cell, row) in
                    self.postLostAndFound()
                })
    }
    
    func postLostAndFound() {
        let value = form.values()
        guard
            let content = value["content"] as? String,
            let anonymous = value["anonymous"] as? Bool
            else {
                hud.showError("请填写完整")
                return
        }
        
        if content.count < 10 {
            hud.showError("表白内容不得少于 10 个字符")
            return
        }
        
        let api = "/api/confession/createConfession"
        let param: HFRequestParam = [
            "content"   :content as AnyObject,
            "anonymous" : anonymous as AnyObject
        ]
        
        var imageData: (name:String,data:Data)?
        
        hud.showLoading("正在发布")
        
        if let image = value["cover"] as? UIImage {
            let newImage    = Utilities.resizeImage(image, newWidth: 1024)
            if let data        = UIImageJPEGRepresentation(newImage, 0.9) {
                imageData = (Utilities.getJpgFileName(),data)
            }
        }
        
        HFBaseRequest.fire(api, image: imageData, params: param, succesBlock: { (request, resultDic) in
            hud.showMassage("发布成功")
            self.pop()
        }) { (request, error) in
            hud.showError(error)
        }
        
        AnalyseManager.PostLoveWall.record()
    }
}

