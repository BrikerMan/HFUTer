
//
//  HFMineMessageViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/5/9.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import PromiseKit

class HFMineMessageViewModel {
    
    var messagePage = 0
    
    func loadMessageFirstPage() -> Promise<[HFMineMessageModel]> {
        messagePage = 0
        return loadMessage(page: messagePage)
    }
    
    
    func loadMessageNextPage() -> Promise<[HFMineMessageModel]> {
        messagePage += 1
        return loadMessage(page: messagePage)
    }
    
    
    func loadMessage(page: Int) -> Promise<[HFMineMessageModel]> {
        return Promise<[HFMineMessageModel]> { fullfill, reject in
            HFAPIRequest
                .buildPromise(api: "api/user/messageList",
                              param: ["pageIndex": page])
                .then { json -> Void in
                    var models: [HFMineMessageModel] = []
                    for item in json.arrayValue {
                        let model = HFMineMessageModel(json: item)
                        models.append(model)
                    }
                    fullfill(models)
                }.catch { error in
                    reject(error)
            }
        }
    }
}
