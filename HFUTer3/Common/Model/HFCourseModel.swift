//
//  HFCourseModel.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/17.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel
import PromiseKit

@available(*, deprecated)
struct CourseHourModel {
    var name = "course"
    var models:[HFCourseModel]
    
    
    init(model:[HFCourseModel]) {
        self.name    = "course"
        self.models  = model
    }
}

extension CourseHourModel: Equatable {}

@available(*, deprecated)
func ==(lhs: CourseHourModel, rhs: CourseHourModel) -> Bool {
    if lhs.models.count == rhs.models.count {
        var allSame = true
        for i in 0..<lhs.models.count {
            if lhs.models[i].name != rhs.models[i].name {
                allSame = false
            }
        }
        return allSame
    }
    return false
}

@available(*, deprecated)
struct CourseDayModel {
    var name  = "CourseDay"
    var hours : [CourseHourModel]
    
    init(hours:[CourseHourModel]) {
        self.name  = "CourseDay"
        self.hours = hours
    }
}

@available(*, deprecated)
class HFCourseModel: NSObject {
    /// 课程名称
    var name  = ""
    /// 地点
    var place = ""
    /// 周数
    var weeks:[Int] = []
    /// 星期几
    var dayNum = 0
    /// 第几节
    var hourNum = 0
    
    
    class func saveCourses(_ data: [String:AnyObject]) {
        PlistManager.dataPlist.saveValues(data)
    }
    
    class func save(json: JSONItem) {
        
    }
    
    class func read(for week: Int) -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            if DBManager.count(from: HFBDTable.schedule) > 0 {
                Logger.debug(("读取缓存课表成功"))
                reject(HFParseError.fullfill)
            } else {
                Logger.error(("读取缓存课表失败"))
                fullfill()
            }
        }
    }
    
    
    class func readCourses(forWeek week:Int) -> [CourseDayModel]? {
        if let
            dic = PlistManager.dataPlist.getValues(),
            let list = dic[PlistKey.ScheduleList.rawValue] as? NSArray, list.count >= 7 {
            let days = self.parsePlist(forWeek: week, list: list)
            return days
        }
        return nil
    }
    
    
    class func parsePlist(forWeek week:Int,list:NSArray) -> [CourseDayModel]{
        var dayList:[CourseDayModel] = []
        for day in list {
            var hours:[CourseHourModel] = []
            if let dayDic = day as? NSDictionary, let hourList = dayDic["dayCourseList"] as? NSArray {
                for hour in hourList {
                    var models = [HFCourseModel]()
                    if let hour = hour as? NSDictionary,
                        let data = hour["courses"] as? [[String: AnyObject]] {
                        for cor in data {
                            if let model = HFCourseModel.yy_model(withJSON: cor) {
                                if let week = cor["week"] as? [Int] {
                                    model.weeks = week
                                }
                                
                                if model.weeks.contains(week) || week == 0 {
                                    models.append(model)
                                }
                            }
                        }
                    }
                    let course = CourseHourModel(model: models)
                    hours.append(course)
                }
            }
            let day = CourseDayModel(hours: hours)
            dayList.append(day)
        }
        return dayList
    }
}
