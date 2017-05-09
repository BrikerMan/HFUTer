//
//  HFCommunityDetailViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/5/9.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import PromiseKit


class HFCommunityDetailViewModel {
    var model: HFComLoveWallListModel!
    
    var commentPage = 0
    
    func loadDetail() -> Promise<HFComLoveWallListModel> {
        return Promise<HFComLoveWallListModel> { fullfill, reject in
                HFAPIRequest.buildPromise(api: "api/confession/detail",
                                          method: .POST,
                                          param: ["id": model.id])
                    .then { json -> Void in
                        self.model.update(json: json)
                        fullfill(self.model)
                    }.catch { error in
                        reject(error)
            }
        }
    }
    
    func loadComments(page: Int) -> Promise<[HFComLoveWallCommentModel]> {
        commentPage = page
        return Promise<[HFComLoveWallCommentModel]> { fullfill, reject in
            HFAPIRequest.buildPromise(api: "api/confession/commentList",
                                      method: .POST,
                                      param: ["id": model.id, "pageIndex": page])
                .then { json -> Void in
                    var models = [HFComLoveWallCommentModel]()
                    for item in json.arrayValue {
                        let model = HFComLoveWallCommentModel(json: item)
                        models.append(model)
                    }
                    fullfill(models)
                }.catch { error in
                    reject(error)
            }

        }
    }
    
    func loadNextComments() -> Promise<[HFComLoveWallCommentModel]> {
        return loadComments(page: commentPage + 1)
    }
}
