//
//  HFScheduleModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/11.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import FMDB

/*
 {
	"name": "形势与政策（2）",
	"place": "西二302",
	"week": [3, 5, 7, 9]
 }
 */

class RealmScheduleWeek {
    var id : Int = 0

}


class HFScheduleModel: SQLiteCachable {
    var id = UUID().uuidString
    
    var name        : String = ""
    var colorName   : String = ""
    
    var isHidden    : Bool    = false
    var isUserAdded : Bool    = false
    
    var hour  = 0
    var day   = 0
    
    var weeks = [RealmScheduleWeek]()
    
    init() {
        
    }
    
    required init(row: FMResultSet) {
        
    }
    
    init(json: JSONItem, day: Int, hour: Int) {
        self.hour = hour
        self.day  = day
        
        self.name = json["name"].stringValue
        for item in json["week"].arrayValue {
            let week = RealmScheduleWeek()
            week.id  = item.intValue
            self.weeks.append(week)
        }
    }
    
    
    func insertSQLStatement(tableName: String) -> (sql: String, values: [Any]) {
        return ("INSERT OR REPLACE INTO \(tableName) (id, name, colorName, isHidden, isUserAdded, hour, day) values (?, ?, ?, ?, ?, ?, ?);",
            [id, name, colorName, isHidden, isUserAdded, hour, day])
    }
}
