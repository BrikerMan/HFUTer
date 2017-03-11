//
//  HFGradesModel.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/19.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel

class HFGradesModel:NSObject {
    var name = ""
    var code = ""
    var classCode = ""
    
    var score = ""
    var makeup = ""
    var credit = ""
    var gpa = ""
    
    var isSelected = false
}

class HFTermModel:NSObject {
    var term = ""
    var scoreList:[HFGradesModel] = []
    
    
    // 初始化放在这里，这里处理镶嵌Json
    class func initModel(_ data: AnyObject) -> HFTermModel? {
        if let dic = data as? [String: AnyObject],
        let model =  HFTermModel.yy_model(with: dic),
        let scroesJson = dic["scoreList"] as? [AnyObject] {
            var list: [HFGradesModel] = []
            for json in scroesJson {
                if let grade = HFGradesModel.yy_model(withJSON: json) {
                    list.append(grade)
                }
            }
            model.scoreList = list
            return model
        }
        return nil
    }
    
    class func saveModels(_ models: [HFTermModel]) {
        var list:[NSDictionary] = []
        for model in models {
            let modelDic = model.yy_modelToJSONObject() as! NSDictionary
            list.append(modelDic)
        }
        let data = [PlistKey.GradesList.rawValue:list]
        PlistManager.dataPlist.saveValues(data as [String : AnyObject])
    }
    
    class func readModels() -> [HFTermModel]? {
        if let dic = PlistManager.dataPlist.getValues(),
            let list = dic[PlistKey.GradesList.rawValue] as? [AnyObject] {
            var models:[HFTermModel] = []
            for item in list {
                if let model = HFTermModel.initModel(item) {
                    models.append(model)
                }
            }
            return models
        }
        return nil
    }
    
    class func saveCalculatorModels(_ models:[HFTermModel]) {
        var list:[NSDictionary] = []
        for model in models {
            let modelDic = model.yy_modelToJSONObject() as! NSDictionary
            list.append(modelDic)
        }
        let data = [PlistKey.CalculateGradesList.rawValue:list]
        PlistManager.dataPlist.saveValues(data as [String : AnyObject])
    }
    
    class func readCalculatorModels() -> [HFTermModel]? {
        if let dic = PlistManager.dataPlist.getValues(),
            let list = dic[PlistKey.CalculateGradesList.rawValue] as? [AnyObject] {
            var models:[HFTermModel] = []
            for item in list {
                if let model = HFTermModel.initModel(item) {
                    models.append(model)
                }
            }
            return models
        }
        return nil
    }
}
