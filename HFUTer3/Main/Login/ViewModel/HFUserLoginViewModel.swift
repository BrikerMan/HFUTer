//
//  HFUserLoginViewModel.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel

class HFUserLoginViewModel {
    func prepareModel(fromDictionary dic:[String:AnyObject]) -> HFUserModel?{
        if let data = dic["data"] {
            let model = HFUserModel.yy_model(withJSON: data)
            return model
        }
        return nil
    }
}
