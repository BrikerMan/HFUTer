//
//  HFUserInfoUpdateRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/18.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFUserInfoChangeRequest: HFBaseAPIManager {
    
    var email: String?
    var image: String?
    
    func updateEmail(email: String) {
        self.email = email
        self.loadData()
    }
    
    func updateImage(image: String) {
        self.image = image
        self.loadData()
    }
    
    
    override func reqeustSubURL() -> String? {
        return "/api/user/updateUserInfo"
    }
    
    override func requestParams() -> [String : Any]? {
        var param: [String : Any] = [:]
        
        if let image = image {
            param["image"] = image
        }
        
        if let email = email {
            param["email"] = email
        }
        
        return param
    }
}
