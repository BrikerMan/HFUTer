//
//  HFCommunityPostLostAndFoundVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFCommunityPostLostAndFoundVC: HFFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        navTitle = "发布失物招领"
    }
    
    
    fileprivate func initUI() {
        form +++ Section("")
            <<< SegmentedRow<String>("type") { $0.options = ["寻物启事", "拾物招领"] }
            
            <<< TextRow("thing") {
                $0.title = "物品"
                $0.placeholder = "丢失/拾到物品名称"
            }
            
            <<< TextRow("place") {
                $0.title = "地点"
                $0.placeholder = "丢失/拾到物品地点"
            }
            
            <<< DateRow("date") {
                $0.value = NSDate() as Date; $0.title = "日期"
                }.cellSetup({ (cell, row) in
                    row.minimumDate = NSDate().addingTimeInterval(-604800.0 * 2) as Date
                    row.maximumDate = NSDate() as Date
                })
            
            <<< AlertRow<String>("datetime") {
                $0.title = "丢失时间"
                $0.options = ["不确定","上午","中午","下午","晚上"]
                $0.value = "不确定"
                $0.selectorTitle = "选择大概丢失/拾到时间"
            }
            
            
            <<< TextAreaRow("decs") {
                $0.placeholder = "描述详细信息"
            }
            
            
            //            <<< ImageRow("image0"){
            //                $0.title = "物品图片"
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
        // check
        let value = form.values()
        guard
        let type  = value["type"] as? String,
        let thing = value["thing"] as? String,
            let place = value["place"] as? String,
        let date = value["date"] as? Date,
        let datetime = value["datetime"] as? String,
        let decs = value["decs"] as? String,
        let anonymous = value["anonymous"] as? Bool
        else {
                hud.showError("请填写完整")
                return
        }
        
        var params:HFRequestParam = [
            "thing":thing as AnyObject,
            "place":place as AnyObject,
            "content":decs as AnyObject
        ]
        
        params["type"] = (type == "寻物启事" ? 0 : 1)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        params["time"] = formatter.string(from: date) + " " + datetime
        params["anonymous"] = anonymous as AnyObject?
        
        print(params)
        fire(params)
    }
    
    func fire(_ params:HFRequestParam) {
        
        AnalyseManager.PostLostThing.record()
        
        HFBaseRequest.fire("/api/lostFound/publishLostFound", method: HFBaseAPIRequestMethod.POST, params: params, succesBlock: { (request, resultDic) in
            print(resultDic)
            hud.showMassage("发布成功")
            self.pop()
            }) { (request, error) in
                hud.showError(error)
        }
    }
    
}
