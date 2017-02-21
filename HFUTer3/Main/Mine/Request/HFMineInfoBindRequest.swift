//
//  HFMineInfoBindRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
class HFMineInfoBindRequest: HFBaseAPIManager {
    
    /// 校区（0：信息门户；1：教务系统；不区分宣城，后台会自己判断）
    var which = 0
    var password = ""
    
    func bindWithData(_ which:Int, password:String) {
        self.which = which
        self.password = password
        self.loadData()
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/bound"
    }
    
    override func errorMessage() -> String? {
        return "绑定失败，请输入正确密码"
    }
    
    override func requestParams() -> [String : Any]? {
        return [
            "which":which,
            "pwd":password
        ]
    }
}
