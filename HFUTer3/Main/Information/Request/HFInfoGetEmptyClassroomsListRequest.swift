//
//  HFInfoGetEmptyClassroomsListRequest.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGetEmptyClassroomsListRequest: HFBaseAPIManager {
    override func reqeustSubURL() -> String? {
        return "/api/user/query/emptyClassRoom"
    }
    
    override func reqeustType() -> HFBaseAPIRequestMethod {
        return .GET
    }
    
    static func handleData(_ dic:[String:AnyObject]) -> HFInfoEmptyClassroomModel? {
        if let json = dic[JSONDataKey],let model = HFInfoEmptyClassroomModel.yy_model(withJSON: json) {
            return model
        }
        return nil
    }
}
