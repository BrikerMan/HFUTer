//
//  HFAcademicClassListModel.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/22.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel


class HFAcademicClassTermModel:NSObject {
    var termCode = ""
    var list: [HFAcademicClassListModel] = []
    //    init?(data:AnyObject) {
//        if let data = data as? [String: AnyObject] {
//            termCode    = data["termCode"] as? String ?? ""
//            if let datalist = data["list"] as?  [AnyObject] {
//                for item in datalist {
//                    if let model = HFAcademicClassListModel(data: item) {
//                        list.append(model)
//                    }
//                }
//            }
//        } else {
//            return nil
//        }
//    }
}

class HFAcademicClassListModel:NSObject{
    var code = ""
    var name = ""
    var classCode = ""
    
//    convenience init?(data:AnyObject) {
//        if let data = data as? [String: AnyObject] {
//            self.init(dic:data)
//        } else {
//            return nil
//        }
//    }
//    
//    init(dic:[String: AnyObject]) {
//        code        = dic["code"] as? String ?? ""
//        name        = dic["name"] as? String ?? ""
//        classCode   = dic["classCode"] as? String ?? ""
//    }
}

class HFAcademicClassDetailModel:NSObject{
    var id = ""
    var sid = ""
    var name = ""
}
