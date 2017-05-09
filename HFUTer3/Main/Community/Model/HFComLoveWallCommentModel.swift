//
//  HFComLoveWallCommentModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYText

class HFComLoveWallCommentModel {
    var id       = 0
    var name     = ""
    
    var content  = ""
    var image    = ""
    var date_int = 0
    var uid      = 0
    
    var at       :[HFComLoveWallCommentAtModel] = []
    
    // 是否为楼主
    var poster = false
   
    // 是否为当前发送者
    var mine   = false
    
    var detailLayout : YYTextLayout? /// 详情页文字布局
    
    init() { }
    
    init(json: JSONItem) {
        self.id   = json["id"].intValue
        self.name = json["name"].stringValue
        
        self.uid      = json["uid"].intValue
        self.content  = json["content"].stringValue
        self.image    = json["image"].stringValue
        self.date_int = json["date_int"].intValue
      
        var ats:[HFComLoveWallCommentAtModel] = []
        for item in json["at"].arrayValue {
            ats.append(HFComLoveWallCommentAtModel(json: item))
        }
        self.at = ats
        
        self.poster = json["poster"].boolValue
        self.mine   = json["mine"].boolValue
    }
}

class HFComLoveWallCommentAtModel {
    var id    = 0
    var name  = ""
    
    init() {
        
    }
    
    init(json: JSONItem) {
        self.id   = json["id"].intValue
        self.name = json["name"].stringValue
    }
}
