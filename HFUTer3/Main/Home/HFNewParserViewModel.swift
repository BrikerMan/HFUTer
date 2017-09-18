//
//  HFNewParserViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/9/13.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import PromiseKit
import PromiseKit.AnyPromise
import Alamofire

class kURL {
  static let login = "http://jxglstu.hfut.edu.cn/eams5-student/login"
  static let get_data = "http://jxglstu.hfut.edu.cn/eams5-student/for-std/course-table/get-data"
  static let timetable_layout = "http://jxglstu.hfut.edu.cn/eams5-student/ws/schedule-table/timetable-layout"
  static let datum = "http://jxglstu.hfut.edu.cn/eams5-student/ws/schedule-table/datum"
}

typealias JSONPromise = Promise<JSONItem>

class HFNewParserViewModel {
  
  var originalData = JSONItem()
  var timetable = JSONItem()
  var datum = JSONItem()
  
  func login() {
    
    getLoginSalt().then { salt in
      self.login_with_id(id: "2014213893", pass: "280017", salt: salt)
      }.then { json -> Promise<JSONItem> in
        return HFRequest.get(kURL.get_data + "?bizTypeId=2&semesterId=32&dataId=67391")
        
      }.then { json -> Promise<JSONItem> in
        self.originalData = json
        return HFRequest.post(kURL.timetable_layout,
                              parameters: ["timeTableLayoutId": json["timeTableLayoutId"].intValue])
      }.then { json -> Promise<JSONItem> in
        self.timetable = json
        var ids = [Int]()
        for id in self.originalData["lessonIds"].arrayValue {
          ids.append(id.intValue)
        }
        return HFRequest.post(kURL.datum,
                              parameters: ["lessonIds": ids, "studentId":67391])
      }.then { json -> Void in
        self.datum = json
      }.catch { error in
        Logger.error(error.localizedDescription)
    }
  }
  
  func login_with_id(id: String, pass: String, salt: String) -> Promise<JSONItem> {
    let params: JSON = [
      "username":  id,
      "password":  ("\(salt)-\(pass)".sha1()),
      "captcha":""
    ]
    return HFRequest.post(kURL.login,
                          parameters: params)
  }
  
  
  func getLoginSalt() -> Promise<String> {
    return Promise { fulfill, reject in
      Alamofire.request("http://jxglstu.hfut.edu.cn/eams5-student/login-salt")
        .responseString { (response) in
          if let salt = response.result.value {
            fulfill(salt)
          } else {
            reject(response.error!)
          }
      }
    }
  }
}

class HFRequest {
  static func get(_ url: String) -> JSONPromise {
    return Alamofire.request(url).promise()
  }
  
  static func post(_ url: String, parameters: JSON = JSON()) -> JSONPromise {
    return Alamofire.request(url,
                             method: .post,
                             parameters: parameters,
                             encoding: JSONEncoding.default).promise()
  }
}


extension DataRequest {
  func promise() -> Promise<JSONItem> {
    return Promise<JSONItem> { fulfill, reject in
      self.responseJSON { (response) in
        if let json = response.result.value as? JSON {
          let j = JSONItem(dictionary: json)
          print(j)
          fulfill(j)
        } else {
          reject(response.error!)
        }
      }
    }
  }
}
