//
//  HFInfoGetChargesRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGetChargesRequest: HFBaseAPIManager {
    override func reqeustSubURL() -> String? {
        return "/api/user/query/charge"
    }
    
    static func handleData(_ dic:[String:AnyObject]) -> (summary:String, termList: [HFInfoChargeTermModel] ){
        var termList: [HFInfoChargeTermModel] = []
        var summary = ""
        if let dataDic = dic["data"] as? [String:AnyObject] {
            summary = dataDic["summary"] as? String ?? ""
            if let array = dataDic["termList"] as? [AnyObject]{
                for item in array {
                    if let model = HFInfoChargeTermModel.initModel(item) {
                    termList.append(model)
                    }
                }
            }
        }
        
        return (summary,termList)
    }
}
