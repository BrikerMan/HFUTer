//
//  HFGetMineNotifReqeust.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/4.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFGetMineNotifReqeust: HFBaseAPIManager {
    var page = 0
    
    func loadNextPage() {
        page += 1
        self.loadData()
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/noticeList"
    }
    
    override func requestParams() -> [String : Any]? {
        return [
            "pageIndex":page
        ]
    }
    
    static func handleData(_ data:HFRequestParam) -> [HFMineNotifModel] {
        var models = [HFMineNotifModel]()
        
        if let list = data["data"] as? [AnyObject] {
            for item in list {
                if let model = HFMineNotifModel.yy_model(withJSON: item) {
                    models.append(model)
                }
            }
        }
        
        return  models
    }
    
}
