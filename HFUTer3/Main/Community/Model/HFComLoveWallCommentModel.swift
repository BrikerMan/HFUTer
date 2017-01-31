//
//  HFComLoveWallCommentModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYText

class HFComLoveWallCommentModel: HFBaseModel {
    var name     = ""
    var id       = 0
    var content  = ""
    var image    = ""
    var date_int = 0
    var uid      = 0
    var at       : [HFComLoveWallCommentAtModel] = []
    
    var detailLayout : YYTextLayout? /// 详情页文字布局
    
//    static func ==(lhs: HFComLoveWallCommentModel, rhs: HFComLoveWallCommentModel) -> Bool {
//        return lhs.id == rhs.id
//    }
}



class HFComLoveWallCommentAtModel: HFBaseModel {
    var id    = 0
    var name  = ""
}
