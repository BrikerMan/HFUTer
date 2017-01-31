//
//  HFGetCommunityLostAndFindRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/4/18.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFGetCommunityLostAndFindRequest: HFBaseAPIManager {
    var page = 0
    var isMine = false
    
    func loadNextPage() {
        page += 1
        loadData()
    }
    
    override func reqeustSubURL() -> String? {
        if isMine {
            return "/api/user/lostFoundList"
        } else {
            return "/api/lostFound/getList"
        }
    }
    
    override func requestParams() -> [String : AnyObject]? {
        return ["pageIndex":page as AnyObject]
    }
    
    static func handleData(_ data:HFRequestParam) -> [HFComLostFoundModel] {
        var models = [HFComLostFoundModel]()
        
        if let list = data["data"] as? [AnyObject] {
            for item in list {
                if let model = HFComLostFoundModel.yy_model(withJSON: item) {
                    models.append(model)
                }
            }
        }
        
        AnalyseManager.UpdateLostThings.record()
        return  models
    }
    
}
