//
//  HFLoginRegisterRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFLoginRegisterRequest: HFBaseAPIManager {
    
    var username = ""
    var password = ""
    var type = 0
    
    func startRegister(withUsername username:String, password: String, type:Int) {
        self.username = username
        self.password = password
        self.type = type
        self.loadData()
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/register"
    }
    
    override func requestParams() -> [String : AnyObject]? {
        return [
            "sid":username as AnyObject,
            "pwd":password as AnyObject,
            "which":type as AnyObject
        ]
    }
}
