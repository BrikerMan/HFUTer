//
//  CommonRequests.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

/// 更新用户信息请求
class HFUpdateUserInfoRequest: HFBaseAPIManager {
    override func reqeustSubURL() -> String? {
        return "/api/user/getUserInfo"
    }
}

/// 获取七牛Token
class HFGetQiniuTokenRequest: HFBaseAPIManager {
    override func reqeustSubURL() -> String? {
        return "/api/getQiNiuToken"
    }
}