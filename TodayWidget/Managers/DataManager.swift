//
//  DataManager.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/8/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation





class DataManager {
    static let shared = DataManager()
    var HFSemesterStartTime = PlistManager.settingsPlist.getValues()?["HFSemesterStartTime"] as? Int ?? 1487520000
    let dayNames = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日", "星期一"]
    
    func getHeaderString(_ isToday: Bool = true) -> String {
        var week = self.calculateCurrentWeek()
        let day  = getDayOfWeek()
        let dayName  = isToday ? dayNames[day - 1] : dayNames[day]
        
        if day == 7 && !isToday{
            week += 1
        }
        
        return "\(dayName) - 第 \(week) 周"
    }
    
    /**
     计算当前是第几周
     这次两边开学时间一致，没做区分计算
     */
    func calculateCurrentWeek() -> Int {
        let from = TimeInterval(HFSemesterStartTime)
        let now = (Date().timeIntervalSince1970)
        var week = Int((now - from)/(7 * 24 * 3600)) + 1
        if week < 0 {
            week = 0
        }
        return week
    }
    
    func getDayOfWeek()->Int {
        let todayDate = Date()
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
        var weekDay = myComponents.weekday! - 1
        if weekDay == 0 {
            weekDay = 7
        }
        return weekDay
    }
    
    func getTodayCorse() -> [HFCourceViewModel] {
        return getCource(true)
    }
    
    func getTomoorCourse() -> [HFCourceViewModel] {
        return getCource(false)
    }

    
    fileprivate func getCource(_ today: Bool) -> [HFCourceViewModel] {
        var week = calculateCurrentWeek()
        
        var day = getDayOfWeek()
        if today {
            day -= 1
        } else {
            if day == 7 {
                day = 0
                week += 1
            }
        }
        
        let models = HFScheduleModel.read(for: week).filter({ $0.day == day })
        let group = HFCourceViewModel.group(schedules: models)
        return group.sorted(by: { $0.start < $1.start })
    }
}
