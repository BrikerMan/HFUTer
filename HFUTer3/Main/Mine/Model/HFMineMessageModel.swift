//
//  HFMineMessageModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/4.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFMineMessageModel {
    var id       = 0
   
    var message  = ""
    var name     = ""
    var date_int = 0
    
    var sImage   = ""
    var type     = 0
    var type_id  = 0
    init() {
        
    }
    
    init(json: JSONItem) {
        id = json["id"].intValue
       
        name    = json["name"].stringValue
        message = json["message"].stringValue
        sImage  = json["sImage"].stringValue
        
        date_int = json["date_int"].intValue
        type     = json["type"].intValue
        type_id  = json["type_id"].intValue
    }
}
