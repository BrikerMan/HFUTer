//
//  HFInfoGetPlansListRequst.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGetPlansListRequst: HFBaseAPIManager {
    override func reqeustSubURL() -> String? {
        return "/api/user/query/plan"
    }
    
    override func reqeustType() -> HFBaseAPIRequestMethod {
        return .GET
    }
    
    static func handleData(_ dic:[String: AnyObject]) -> HFInfoPlanListModel? {
        if let json = dic[JSONDataKey],
            let model = HFInfoPlanListModel.yy_model(withJSON: json) {
            return model
        }
        return nil
    }
}
