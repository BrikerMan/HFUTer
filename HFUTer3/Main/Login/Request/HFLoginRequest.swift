//
//  HFLoginRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFLoginRequest: HFBaseAPIManager {
    
    var username = ""
    var password = ""
    
    func startLogin(withUsername username:String, password: String) {
        self.username = username
        self.password = password
        self.loadData()
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/user/login"
    }
    
    override func requestParams() -> [String : AnyObject]? {
        return [
            "sid":username as AnyObject,
            "pwd":password.md5() as AnyObject
            ]
    }
}
