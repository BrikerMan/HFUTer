//
//  HFComLoveWallListModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/9.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYText

class HFComLoveWallListModel: HFBaseModel {
    var commentCount    = 0
    var content         = ""
    var date            = 0
    var date_int         = 0
    var favorite        = false
    var favoriteCount   = 0
    var id              = 0
    var image           = ""
    var name            = ""
    var color           = 0
    
    // 表白照片
    var cImage:String?
    
    
    var listLayout: YYTextLayout?
}
