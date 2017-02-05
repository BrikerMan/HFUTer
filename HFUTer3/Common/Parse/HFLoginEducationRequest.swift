//
//  HFLoginEducationRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/2/4.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Pitaya
import Gzip

typealias EducationProgressDataBlock = (_ progress: String, _  finsihed: Bool, _ success: Bool, _ data: Data?) -> Void
typealias EducationProgressJSONBlock = (_ progress: String, _  finsihed: Bool, _ success: Bool, _ data: JSONItem) -> Void

class HFEducationRequest {
    
    static var hasLogin = false
    
    
    
    
    static func getSchedule(progressBlock: @escaping EducationProgressJSONBlock) {
        login { (progress, finished, success, data) in
            if finished {
                progressBlock(progress, false, false, JSONItem())
                getScheduleFromWebRequest(progress: { (progress, finished, success, data) in
                    progressBlock(progress, false, false, JSONItem())
                    if let data = data {
                        parseScheduleData(data: data, progress: { (progress, finished, success, data) in
                            if finished {
                                progressBlock(progress, true, success, data["data"])
                            } else {
                                progressBlock(progress, false, false, JSONItem())
                            }
                            
                        })
                    }
                })
            } else {
                progressBlock(progress, false, false, JSONItem())
            }
        }
    }
    
    
    
    static func login(progress: @escaping EducationProgressDataBlock) {
        progress("登录教务系统 ...",false, false, nil)
        let url = EduURL.xchost + EduURL.login
        Pita.build(HTTPMethod: .POST, url: url)
            .setHTTPHeader(Name: "Content-Type", Value: "application/x-www-form-urlencoded")
            .setHTTPBodyRaw("UserStyle=student&user=2015218508&password=824fc699")
            .responseData { (data, response) in
                if let data = data {
                    let str = String(data: data, encoding: .gb2312) ?? ""
                    print(str)
                    if str.contains("密码验证") {
                        progress("密码错误，请核实" ,true , false, nil)
                    } else {
                        progress("登入教务系统成功" ,true , true, nil)
                    }
                }
        }
    }
    
    /// 从服务器获取 HTTP 数据
    static func getScheduleFromWebRequest(progress: @escaping EducationProgressDataBlock) {
        progress("获取课表 ...",false, false, nil)
        let url = EduURL.xchost + EduURL.schedule
        Pita.build(HTTPMethod: .GET, url: url)
            .responseData { (data, response) in
                progress("获取课表成功", true, true, data)
        }
    }
    
    
    static func parseScheduleData(data: Data, progress: @escaping EducationProgressJSONBlock) {
        progress("解析课表 ...",false, false, JSONItem())
        let compressedData: Data = try! data.gzipped()
        let file = File(name: "course", data: compressedData, type: "html")
        let url  = APIBaseURL + "/api/schedule/uploadSchedule"
        let str = String(data: data, encoding: .gb2312) ?? ""
        print("HTML Reponse" + str)
        Pita.build(HTTPMethod: .POST, url: url)
            .addFiles([file])
            .responseJSON({ (json, response) in
                print(json)
                let success = json["statue"].intValue == 1
                if success {
                    progress("解析成功", true, true, json)
                } else {
                    progress(json["info"].stringValue, true, false, JSONItem())
                }
            })
        
        
    }
    
    

}
