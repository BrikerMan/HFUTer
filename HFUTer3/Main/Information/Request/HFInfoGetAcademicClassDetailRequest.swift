//
//  HFInfoGetAcademicClassDetailRequest.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/21.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGetAcademicClassDetailRequest:HFBaseAPIManager{
    
    var termCode = "" //学期代码
    var code     = "" //课程代码
    var classCode = "" //教学班号
    
    func startQuery(withTermcode termCode:String,code:String,classCode:String){
        self.termCode = termCode
        self.code = code
        self.classCode = classCode
        self.loadData()
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/user/query/classDetail"
    }
    
    override func requestParams() -> [String : AnyObject]? {
        return [
            "termCode":termCode as AnyObject,
            "code":code as AnyObject,
            "classCode":classCode as AnyObject
        ]
    }
}
