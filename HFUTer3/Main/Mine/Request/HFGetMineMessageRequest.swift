//
//  HFGetMineMessageRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/4.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

@available(*, deprecated)
class HFGetMineMessageRequest: HFBaseAPIManager {
    var page = 0
    
    func loadNextPage() {
        page += 1
        self.loadData()
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/user/messageList"
    }
    
    override func requestParams() -> [String : Any]? {
        return [
            "pageIndex":page
        ]
    }
    
    // TODO: clean up
    static func handleData(_ data:HFRequestParam) -> [HFMineMessageModel] {
        let models = [HFMineMessageModel]()
        
//        if let list = data["data"] as? [AnyObject] {
//            for item in list {
//                if let model = HFMineMessageModel.yy_model(withJSON: item) {
//                    models.append(model)
//                }
//            }
//        }
        
        return  models
    }

}
