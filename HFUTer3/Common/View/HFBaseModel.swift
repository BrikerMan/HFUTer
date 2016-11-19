//
//  HFBaseModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/4/18.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel

class HFBaseModel: NSObject {
    override var description: String {
        get {
            var result = ""
            if let decs = self.yy_modelToJSONObject() as? [String:AnyObject] {
                for (key, value) in decs {
                    result = result + "\(key): \(value) \n"
                }
                return result
            } else {
                return "格式化失败"
            }
        }
    }
    
    
    
    func toDic() -> [String:AnyObject] {
        return self.yy_modelToJSONObject() as! [String:AnyObject]
    }
}