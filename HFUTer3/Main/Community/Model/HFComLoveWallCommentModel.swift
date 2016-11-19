//
//  HFComLoveWallCommentModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFComLoveWallCommentModel: HFBaseModel {
    var name     = ""
    var id       = 0
    var content  = ""
    var image    = ""
    var date_int = 0
    var uid      = 0
    var at       : [HFComLoveWallCommentAtModel] = []
}

class HFComLoveWallCommentAtModel: HFBaseModel {
    var id    = 0
    var name  = ""
}