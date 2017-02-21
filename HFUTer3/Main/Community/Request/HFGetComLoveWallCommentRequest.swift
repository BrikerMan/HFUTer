//
//  HFGetComLoveWallCommentRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFGetComLoveWallCommentRequest: HFBaseAPIManager {
    var page = 0
    var id   = 0
    
    func loadNextPage() {
        page += 1
        loadData()
    }
    
    func fire(_ commentId: Int) {
        self.id = commentId
        self.loadData()
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/confession/commentList"
    }
    
    
    override func requestParams() -> [String : Any]? {
        return [
            "pageIndex":page,
            "id":id
        ]
    }
    
    static func handleData(_ data:HFRequestParam) -> [HFComLoveWallCommentModel] {
        var models = [HFComLoveWallCommentModel]()
        
        if let list = data["data"] as? [AnyObject] {
            for item in list {
                if let model = HFComLoveWallCommentModel.yy_model(withJSON: item) {
                    models.append(model)
                    if let item = item as? HFRequestParam,
                        let at = item["at"] as? [AnyObject] {
                        var ats:[HFComLoveWallCommentAtModel] = []
                        for atItem in at {
                            if let atModel = HFComLoveWallCommentAtModel.yy_model(withJSON: atItem) {
                                ats.append(atModel)
                            }
                        }
                        model.at = ats
                    }
                }
            }
        }
        return  models
    }
}
