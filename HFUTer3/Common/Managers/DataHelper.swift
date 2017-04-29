//
//  DataHelper.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/7/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class DataHelper {
    static func getDaysListForWeek(_ week:Int) -> [String] {
        var startData = 0
        
        if let user = DataEnv.user, week != 0 {
            if user.xc {
                startData = (HFSemesterStartTime)
            } else {
                startData = (XCSemesterStartTime)
            }
            
            startData = startData + ((week - 1) * 7 * 24 * 3600)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M-d"
            
            var weekString:[String] = [""]
            
            for i in 0..<7 {
                let day = startData + (i * 24 * 3600)
                let timeInterval = TimeInterval(day)
                let date = Date(timeIntervalSince1970: timeInterval)
                let string = formatter.string(from: date)
                weekString.append(string)
            }
            return weekString
        } else {
            return Array<String>(repeating: "", count: 10)
        }
    }
}
