//
//  HFCommunityHomeViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation

enum CommunityHomeListTpe {
    case loveWall
    case loveWallHot
}

class HFCommunityLoveViewModel {
    var type = CommunityHomeListTpe.loveWall
    var page = 0
    
    var isMine = false
    
    func loadFirstPage(completion: @escaping ([HFComLoveWallListModel])->Void) {
        page = 0
        loadPage(page: page, completion: completion)
    }
    
    
    func loadNextPage(completion: @escaping ([HFComLoveWallListModel])->Void) {
        page += 1
        loadPage(page: page, completion: completion)
    }

    func loadPage(page: Int, completion: @escaping ([HFComLoveWallListModel])->Void) {
        fireRequest(page: page) { (json) in
            var result = [HFComLoveWallListModel]()
            for item in json.arrayValue {
                let model = HFComLoveWallListModel(json: item)
                result.append(model)
            }
            completion(result)
        }
    }
    
    
    func fireRequest(page: Int, completion: @escaping (_ json: JSONItem) -> Void) {
        var api: String
        var param: JSON = [
            "pageIndex" : page
        ]
        
        switch type {
        case .loveWall:
            api = "api/confession/list"
            param["type"] = 0
            
        case  .loveWallHot:
            api =  "api/confession/list"
            param["type"] = 1
        }
        
        if isMine {
            api = "api/confession/myConfessionList"
        }
        
        HFAPIRequest.build(api: api, method: .POST, param: param)
            .response(callback: { (json, error) in
                if let error = error {
                    Hud.showError(error.hfDescription)
                } else {
                    completion(json)
                }
            })
    }
}
