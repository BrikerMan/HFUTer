//
//  HFInfoGetBookListRequest.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/4/11.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGetBookListRequest: HFBaseAPIManager {
    override func reqeustSubURL() -> String? {
        return "/api/library/bookList"
    }
    
    override func reqeustType() -> HFBaseAPIRequestMethod {
        return HFBaseAPIRequestMethod.GET
    }
    
    static func handleData(_ dic:[String:AnyObject]) -> [HFInfoBookModel] {
        var modelList:[HFInfoBookModel] = []
        if let array = dic[JSONDataKey] as? [AnyObject]{
            for json in array {
                if let model = HFInfoBookModel.yy_model(withJSON: json) {
                    modelList.append(model)
                }
            }
        }
        return modelList
    }
}
