//
//  HFComLoveWallListModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/9.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYText
import RxSwift

class HFComLoveWallListModel {
    var id            = 0
//    var date          = 0
    var date_int      = 0
    
    var content       = ""
    var favorite      = Variable(false)
    var favoriteCount = 0
    var commentCount  = 0
    
    var image         = ""
    var name          = ""
    var color         = 0
    
    // 是否匿名
    var anonymous = false
    
    init() { }
    
    convenience init(json: JSONItem) {
        self.init()
        self.update(json: json)
    }
    
    func update(json: JSONItem) {
        self.id       ??= json["id"].int
        self.date_int ??= json["date_int"].int
       
        self.content        ??= json["content"].string
        self.favorite.value ??= json["favorite"].bool
        self.favoriteCount  ??= json["favoriteCount"].int
        self.commentCount   ??= json["commentCount"].int
        
        self.image ??= json["image"].string
        self.name  ??= json["name"].string
        self.color ??= json["color"].int
        
        self.anonymous ??= json["anonymous"].bool
        
        self.layout = JSON()
    }
    
    // 表白照片
    var cImage : String?
    var cImageSize : CGSize?
    
    var layout: JSON = JSON()
}
