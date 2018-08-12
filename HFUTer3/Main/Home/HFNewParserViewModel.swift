//
//  HFNewParserViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/9/13.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire
import Kanna

class kURL {
  static let host = "http://jxglstu.hfut.edu.cn"
  static let salt = "http://jxglstu.hfut.edu.cn/eams5-student/login-salt"
  static let login = "http://jxglstu.hfut.edu.cn/eams5-student/login"
  static let newCourse = "http://jxglstu.hfut.edu.cn/eams5-student/for-std/course-table"
  static let get_data = "http://jxglstu.hfut.edu.cn/eams5-student/for-std/course-table/get-data"
  static let timetable_layout = "http://jxglstu.hfut.edu.cn/eams5-student/ws/schedule-table/timetable-layout"
  static let datum = "http://jxglstu.hfut.edu.cn/eams5-student/ws/schedule-table/datum"
}

typealias JSONPromise = Promise<JSONItem>

private class Schedule {
  var json: JSONItem
  var startIndex: Int = -1
  var endIndex: Int = -1
  
  var isValid: Bool {
    get {
      if self.startIndex != -1 && self.endIndex != -1 {
        return true
      } else {
        Logger.error("无效课程 \(self.json)")
        return false
      }
    }
  }
  
  init(json: JSONItem, courseUnitList: JSONItem) {
    self.json = json
    for (index, unit) in courseUnitList.arrayValue.enumerated() {
      
      if json["startTime"].intValue == unit["startTime"].intValue {
        self.startIndex = index
      }
      if json["endTime"].intValue == unit["endTime"].intValue {
        self.endIndex = index
      }
    }
  }
}

private class CourseData: Equatable {
  var name: String
  var place: String
  var week: [Int]
  var teachers: [String]
  
  init(lesson: JSONItem, place: String, week: [Int]) {
    self.name = lesson["course"]["nameZh"].stringValue
    self.place = place
    self.week = week
    self.teachers = lesson["teacherAssignmentList"].arrayValue.map { $0["person"]["nameZh"].stringValue }
  }
  
  func toDict() -> JSON {
    return [
      "name": name,
      "place": place,
      "week" : week,
      "teachers": teachers
    ]
  }
  
  static func ==(lhs: CourseData, rhs: CourseData) -> Bool {
    return lhs.name == rhs.name && lhs.place == rhs.place
  }
}

// 每天得课程
private class DayCourses: CustomStringConvertible {
  var dayCourseList = [Courses]()
  // 创建一周的课程， max 每天最多课程
  static func createOneWeekCourses(max: Int) -> [DayCourses]{
    var dayCoursesList = [DayCourses]()
    for _ in 0..<7 {
      let day = DayCourses()
      for _ in 0..<max {
        day.dayCourseList.append(Courses())
      }
      dayCoursesList.append(day)
    }
    return dayCoursesList
  }
  
  func toDict() -> JSON {
    return [
      "dayCourseList": dayCourseList.map { $0.toDict() } ,
    ]
  }
  
  var description: String {
    return "\(self.toDict())"
  }
}

// 每个时间段的课程
private class Courses {
  var courses = [CourseData]()
  
  func toDict() -> JSON {
    return [
      "courses": courses.map { $0.toDict() } ,
    ]
  }
}

class HFNewParserViewModel {
  var dataId = ""
  var semesterId = "32"
  var bizTypeId = "2"
  
  var getDataJson = JSONItem()
  var timeTableJson = JSONItem()
  var datumJson = JSONItem()
  
  func login(id: String, pass: String) -> Promise<JSONItem> {
    return Promise<JSONItem> { fullfill, reject in
      Alamofire.request(kURL.salt).promiseString()
        .then { salt -> Promise<JSONItem> in
          Logger.debug("获取 salt 成功")
          return self.login_with_id(id: id, pass: pass, salt: salt)
        }.then { json in
          fullfill(json)
        }.catch { error in
          reject(error)
      }
    }
  }
  
  
  func fetchData(id: String, pass: String) -> Promise<JSONItem> {
    return Promise<JSONItem> { fullfill, reject in
      self.login(id: id, pass: pass)
        .then { json -> Promise<String> in
          Logger.debug("登录新教务成功")
          return self.getCourceTable()
          
        }.then { html -> Promise<JSONItem> in
          if let doc = try? HTML(html: html, encoding: .utf8) {
            for link in doc.css("option[selected=selected]") {
              if let v = link["value"] {
                self.semesterId = v
              }
            }
          }
          let url = kURL.get_data + "?bizTypeId=\(self.bizTypeId)&semesterId=\(self.semesterId)&dataId=\(self.dataId)"
          return Alamofire.request(url).promiseJSON()
          
        }.then { json  -> Promise<JSONItem> in
          self.getDataJson = json
          
          let params: JSON = [
            "timeTableLayoutId": self.getDataJson["timeTableLayoutId"].intValue
          ]
          return Alamofire.request(kURL.timetable_layout, method: .post, parameters: params, encoding: JSONEncoding.default).promiseJSON()
        }.then { json  -> Promise<JSONItem> in
          
          self.timeTableJson = json["result"]
          var lessonIds = [Int]()
          for item in self.getDataJson["lessonIds"].arrayValue {
            lessonIds.append(item.intValue)
          }
          let params: JSON = [
            "lessonIds": lessonIds,
            "studentId": self.dataId
          ]
          return Alamofire.request(kURL.datum, method: .post, parameters: params, encoding: JSONEncoding.default).promiseJSON()
          
        }.then { json  -> Void in
          Logger.debug("获取全部数据成功，开始拼接")
          self.datumJson = json["result"]
          let result = self.createNewCourseData()
          let array = result.map { $0.toDict() }
          let jsonItem = JSONItem(array: array)
          fullfill(jsonItem)
        }.catch { error in
          Logger.error(error.localizedDescription)
          reject(error)
      }
    }
  }
  
  func login_with_id(id: String, pass: String, salt: String) -> Promise<JSONItem> {
    let params: [String: Any] = [
      "username" : id,
      "password" : ("\(salt)-\(pass)".sha1()),
      "captcha"  : ""
    ]
    
    return Alamofire.request(kURL.login, method: .post, parameters: params, encoding: JSONEncoding.default).promiseJSON()
  }
  
  
  private func createNewCourseData() -> [DayCourses] {
    Logger.verbose("== createNewCourseData ==")
    var lessonItemHashMap = [Int: JSONItem]()
    
    for item in self.getDataJson["lessons"].arrayValue {
      lessonItemHashMap[item["id"].intValue] = item
    }
    
    var dayCoursesList = DayCourses.createOneWeekCourses(max: timeTableJson["courseUnitList"].arrayValue.count)
    
    for json in self.datumJson["scheduleList"].arrayValue {
      let schedule = Schedule(json: json, courseUnitList: self.timeTableJson["courseUnitList"])
      
      if !schedule.isValid {
        continue
      }
      
      var placeText = ""
      if let roomName = schedule.json["room"]["nameZh"].string {
        //        if let campus = schedule.json["room"]["building"]["campus"].string {
        //          placeText = campus + " " + roomName
        //        } else {
        //          placeText = roomName
        //        }
        placeText = roomName
        
        if placeText.last == "*" {
          let chars = String(placeText.dropLast())
          placeText = String(chars)
        }
      }
      
      let lesson = lessonItemHashMap[schedule.json["lessonId"].intValue]!
      let courseData = CourseData(lesson: lesson, place: placeText, week: [])
      
      for i in schedule.startIndex...schedule.endIndex {
        var contains = false
        if let weekday = schedule.json["weekday"].int {
          let courses = dayCoursesList[weekday-1].dayCourseList[i]
          for data in courses.courses {
            if data == courseData {
              if !data.week.contains(schedule.json["weekIndex"].intValue) {
                data.week.append(schedule.json["weekIndex"].intValue)
              }
              contains = true
            }
          }
          
          if (!contains) {
            if !courseData.week.contains(schedule.json["weekIndex"].intValue) {
              courseData.week.append(schedule.json["weekIndex"].intValue)
            }
            courses.courses.append(courseData)
          }
        }
      }
    }
    return dayCoursesList
  }
  
  func getCourceTable() -> Promise<String> {
    return Promise<String>
        { fulfill, reject in
      Alamofire.request(kURL.newCourse, headers: nil).responseString { (response) in
        let url = response.response?.url?.absoluteString ?? "info/67391"
        self.dataId = url.components(separatedBy: "/").last ?? self.dataId
        if let str = response.result.value {
          fulfill(str)
        } else {
          reject(response.error!)
        }
      }
    }
  }
}


extension DataRequest {
  func promiseJSON() -> Promise<JSONItem> {
    return Promise<JSONItem> { fulfill, reject in
      self.responseJSON { (response) in
        if let json = response.result.value as? JSON {
          let j = JSONItem(dictionary: json)
          fulfill(j)
        } else {
          reject(response.error!)
        }
      }
    }
  }
  
  func promiseString() -> Promise<String> {
    return Promise<String> { fulfill, reject in
      self.responseString { (response) in
        if let str = response.result.value {
          fulfill(str)
        } else {
          reject(response.error!)
        }
      }
    }
  }
}
