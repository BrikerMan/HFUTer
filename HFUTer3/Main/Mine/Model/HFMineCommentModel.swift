//
//  HFMineCommentModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/6/21.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFMineCommentModel {
    var id   = 0
    var name = ""
    var date = 0
    var content = ""
    var confession: HFComLoveWallListModel?
    
    
    
    init(json: JSONItem) {
        id = json["id"].intValue
        name = json["name"].stringValue
        date = Int(json["date"].doubleValue / 1000)
        content = json["content"].stringValue
        
        let data = HFComLoveWallListModel(json: json["data"])
        if data.id != -1 {
            confession = data
        }
    }
}
