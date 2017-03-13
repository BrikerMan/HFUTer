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

class HFScheduleModel: SQLiteCachable {
    var id = UUID().uuidString
    
    var name        : String = ""
    var colorName   : String = ""
    
    var isHidden    : Bool    = false
    var isUserAdded : Bool    = false
    
    var hour  = 0
    var day   = 0
    
    var weeks = [Int]()
    
    init() {
        
    }
    
    required init(row: FMResultSet) {
        self.id        = row.string(forColumn : "id")
        self.name      = row.string(forColumn : "name")
        self.colorName = row.string(forColumn : "colorName")
        
        self.isHidden    = row.bool(forColumn : "isHidden")
        self.isUserAdded = row.bool(forColumn : "isUserAdded")
        
        self.hour = Int(row.int(forColumn: "hour"))
        self.day  = Int(row.int(forColumn: "day"))
        
        let weekString = row.string(forColumn: "weeks") ?? ""
        self.weeks = []
        for str in weekString.components(separatedBy: ",") {
            if let w = Int(str) {
                self.weeks.append(w)
            }
        }
    }
    
    init(json: JSONItem, day: Int, hour: Int) {
        self.hour = hour
        self.day  = day
        
        self.name = json["name"].stringValue
        for item in json["week"].arrayValue {
            weeks.append(item.intValue)
        }
    }
    
    
    
    static func read(for week: Int) -> [[HFScheduleModel]] {
        var filter: String?
        if week != 0 {
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 2
            filter = "weeks LIKE '%\(formatter.string(from: 2)!)%'"
        }
        let cources = DBManager.read(from: .schedule, type: HFScheduleModel.self, filter: filter)
        
        var days = Array(repeating: [HFScheduleModel](), count: 7)
        
        for c in cources {
            days[c.day].append(c)
        }
        
        
        return days
    }
    
    
    /// 保存接口返回数据
    static func handlleSchedules(_ json: JSONItem) {
        DBManager.execute(sql: "Delete from schedule where isUserAdded == 0;")
        for (dayIndex, day) in json.arrayValue.enumerated() {
            for (hourIndex, hour) in day["dayCourseList"].arrayValue.enumerated() {
                for cource in hour["courses"].arrayValue {
                    let model = HFScheduleModel(json: cource, day: dayIndex, hour: hourIndex)
                    DBManager.insert(item: model, to: .schedule)
                }
            }
        }
    }
    
    
    func insertSQLStatement(tableName: String) -> (sql: String, values: [Any]) {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        formatter.string(from: 2)
        
        let week = weeks.map{ formatter.string(for: $0)! }
        let weekStr = week.joined(separator: ",")
        return ("INSERT OR REPLACE INTO \(tableName) (id, name, colorName, isHidden, isUserAdded, hour, day, weeks) values (?, ?, ?, ?, ?, ?, ?, ?);",
            [id, name, colorName, isHidden, isUserAdded, hour, day, weekStr])
    }
}
