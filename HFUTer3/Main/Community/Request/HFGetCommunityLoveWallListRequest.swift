//
//  HFGetCommunityLoveWallListRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/9.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

@available(*, deprecated)
class HFGetCommunityLoveWallListRequest: HFBaseAPIManager {
    var page = 0
    var isMine = false
    
    func loadNextPage() {
        page += 1
        loadData()
    }
    
    override func reqeustSubURL() -> String? {
        if isMine {
            return "/api/confession/myConfessionList"
        } else {
            return "/api/confession/list"
        }
    }
    
    
    override func requestParams() -> [String : Any]? {
        return ["pageIndex":page]
    }
    
    // TODO: clean up
    static func handleData(_ data:HFRequestParam, isMine: Bool = false) -> [HFComLoveWallListModel] {
        let models = [HFComLoveWallListModel]()
        
        if let list = data["data"] as? [AnyObject] {
//            for item in list {
//                let model = HFComLoveWallListModel(json: item)
//            
//                result.append(model)
//                
//                if let model = HFComLoveWallListModel.yy_model(withJSON: item) {
//                    if isMine && !model.anonymous {
//                        model.image = DataEnv.user!.image
//                        model.name  = DataEnv.user!.name
//                    }
//                    models.append(model)
//                }
//            }
        }
        
        AnalyseManager.UpdateLoveWall.record()
        return  models
    }
}
