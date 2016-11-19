//
//  HFHomeGetCourseListRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFHomeGetCourseListRequest: HFBaseAPIManager {
    
    var isUpdate = false
    
    override func reqeustSubURL() -> String? {
        if isUpdate {
            return "/api/schedule/update"
        } else {
            return "/api/schedule/schedule"
        }
    }
}