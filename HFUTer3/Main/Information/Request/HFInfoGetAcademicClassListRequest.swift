//
//  HFInfoGetClassListRequest.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/21.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGetAcademicClassListRequest: HFBaseAPIManager {
    override func reqeustSubURL() -> String? {
        return "/api/user/query/classTeaching"
    }
    
    /**
     这个接口用Get方法
     */
    override func reqeustType() -> HFBaseAPIRequestMethod {
        return HFBaseAPIRequestMethod.GET
    }
}