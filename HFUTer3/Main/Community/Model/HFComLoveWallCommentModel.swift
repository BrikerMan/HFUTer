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
    
    // 是否为楼主
    var poster = false
   
    // 是否为当前发送者
    var mine   = false
    
    var detailLayout : YYTextLayout? /// 详情页文字布局
}



class HFComLoveWallCommentAtModel: HFBaseModel {
    var id    = 0
    var name  = ""
}
