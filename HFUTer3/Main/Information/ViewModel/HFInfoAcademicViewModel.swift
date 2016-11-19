//
//  HFInfoAcademicViewModel.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel

/// 因为就俩请求，写在一起了，如果比较多的话 每个页面一个ViewModel
class HFInfoAcademicViewModel {
    static func prepareTermModel(_ dic: [String: AnyObject]) -> HFAcademicClassTermModel? {
        if let data = dic[JSONDataKey],
            let term = HFAcademicClassTermModel.yy_model(withJSON: data),
            let array = data["list"] as? [AnyObject] {
            
            var list = [HFAcademicClassListModel]()
            for item in array {
                if let listItem = HFAcademicClassListModel.yy_model(withJSON: item) {
                    list.append(listItem)
                }
                
            }
            term.list = list
            return term
        }
        return nil
    }
    
    static func prepareClassDetailModels(_ dic: [String: AnyObject]) -> [HFAcademicClassDetailModel]{
        var list: [HFAcademicClassDetailModel] = []
        if let array = dic[JSONDataKey] as? [AnyObject] {
            for json in array {
                if let model = HFAcademicClassDetailModel.yy_model(withJSON: json) {
                    list.append(model)
                }
            }
        }
        return list
    }
}
