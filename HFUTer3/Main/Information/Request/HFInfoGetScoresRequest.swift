//
//  HFInfoGetScoresRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/25.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

/// 测试一下新的解析方法，把解析放在请求里面，发现我们请求和解析都很短，分开放在两个地方好像反而复杂化。
class HFInfoGetScoresRequest: HFBaseAPIManager {
    
    /// 是否刷新，首次直接拉取，之后更新刷新
    var shouldUpdate = false
    
    
    override func reqeustSubURL() -> String? {
        if shouldUpdate {
            return "/api/score/update"
        } else {
            return "/api/score/score"
        }
    }
    
    // 我试试添加一个静态方法来解析
    static func handleData(_ dic:[String:AnyObject]) -> [HFTermModel] {
        var modelList:[HFTermModel] = []
        if let jsonString = dic["data"] as? String, let array = jsonString.jsonToArray() {
            for termjson in array {
                if let term = HFTermModel.initModel(termjson) {
                    modelList.append(term)
                }
            }
        }
        return modelList
    }
}
