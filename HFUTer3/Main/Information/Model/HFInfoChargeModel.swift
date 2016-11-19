//
//  HFInfoChargeModel.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel

class HFInfoChargeCourseModel: NSObject {
    var charge      = ""
    var classCode   = ""
    var code        = ""
    var credit      = ""
    var name        = ""
}

class HFInfoChargeTermModel: NSObject {
    var term = ""
    var termCharge = ""
    var courses: [HFInfoChargeCourseModel] = []
    
    
    static func initModel(_ data: AnyObject) -> HFInfoChargeTermModel? {
        if let dic = data as? [String:AnyObject],
        let model = HFInfoChargeTermModel.yy_model(with: dic),
        let array = dic["courses"] as? [AnyObject] {
            var courses: [HFInfoChargeCourseModel] = []
            for item in array {
                if let course = HFInfoChargeCourseModel.yy_model(withJSON: item) {
                    courses.append(course)
                }
            }
            model.courses = courses
            return model
        }
        
        return nil
    }
    
}

