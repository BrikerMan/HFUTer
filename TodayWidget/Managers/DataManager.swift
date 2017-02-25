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
        let from = TimeInterval(1487520000)
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
    
    func getTodayCorse() -> [HFCourseModel] {
        return getCource(true)
    }
    
    func getTomoorCourse() -> [HFCourseModel] {
        return getCource(false)
    }

    
    fileprivate func getCource(_ today: Bool) -> [HFCourseModel] {
        
        var hours = [HFCourseModel]()
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
        
        if let dayModels = HFCourseModel.readCourses(forWeek: week)?[day] {
            if dayModels.hours.count > 9 {
                for (index,hour) in [0,2,4,6,8].enumerated() {
                    let hour = dayModels.hours[hour]
                    if !hour.models.isEmpty {
                        let model = hour.models.first!
                        model.hourNum = index
                        hours.append(model)
                    }
                }
            }
        }
        
        return hours
    }
}
