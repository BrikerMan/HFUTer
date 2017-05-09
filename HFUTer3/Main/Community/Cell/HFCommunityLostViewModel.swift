//
//  HFCommunityLostViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit


class HFCommunityLostViewModel {
    var page = 0
    var isMine = false
    
    func loadFirstPage(completion: @escaping ([HFComLostFoundModel])->Void) {
        page = 0
        loadPage(page: page, completion: completion)
    }
    
    
    func loadNextPage(completion: @escaping ([HFComLostFoundModel])->Void) {
        page += 1
        loadPage(page: page, completion: completion)
    }
    
    func loadPage(page: Int, completion: @escaping ([HFComLostFoundModel])->Void) {
        fireRequest(page: page) { (json) in
            var result = [HFComLostFoundModel]()
            for item in json.arrayValue {
                if let model = HFComLostFoundModel.yy_model(withJSON: item.RAWValue) {
                    result.append(model)
                }
            }
            completion(result)
        }
    }
    
    func fireRequest(page: Int, completion: @escaping (_ json: JSONItem) -> Void) {
        let api = isMine ? "api/user/lostFoundList" : "api/lostFound/getList"
        let param: JSON = [
            "pageIndex" : page
        ]
        
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
