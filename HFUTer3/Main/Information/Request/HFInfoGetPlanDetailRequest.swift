//
//  HFInfoGetPlanDetailRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGetPlanDetailRequest: HFBaseAPIManager {
    
    var term    = ""
    var style   = 0
    var major   = ""
    
    func fire(_ style:Int, _ term:String, _ major:String) {
        self.style = style
        self.term  = term
        self.major = major
        self.loadData()
    }
    
    override func requestParams() -> [String : Any]? {
        let type = style == 0 ? 1 : 3
        return [
            "term"  : term,
            "style" : type,
            "major" : major
        ]
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/user/query/planList"
    }
    
    static func handleData(_ data:HFRequestParam) -> [HFInfoPlanListDetailModel] {
        var models = [HFInfoPlanListDetailModel]()
        
        if let list = data["data"] as? [AnyObject] {
            for item in list {
                if let model = HFInfoPlanListDetailModel.yy_model(withJSON: item) {
                    models.append(model)
                }
            }
        }
        
        return  models
    }
}
