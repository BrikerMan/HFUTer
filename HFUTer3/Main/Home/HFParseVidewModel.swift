//
//  HFParseVidewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/4.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Pitaya
import PromiseKit
import Gzip

enum HFParseError: Error {
    case fullfill
    case loginError
    case getHtmlFail
    case suspend(info: String)
}

extension Error {
    var description: String {
        if let error = self as? HFParseError {
            switch error {
            case .fullfill:
                return "成功啦"
            case .loginError:
                return "登录失败"
            case .getHtmlFail:
                return "获取html数据失败"
            case .suspend(let info):
                return info
            }
        }
        return self.localizedDescription
    }
    
    var isFullfill: Bool {
        if let error = self as? HFParseError {
            switch error {
            case .fullfill:
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }
}


typealias HFParseScheduleResult = ((_ models: [CourseDayModel], _ error: HFParseError?) -> Void)

//enum HFParseRequestState {
//    case readingCache
//    case loadFromServer
//    case loadFromJW
//    case
//}

///## 课表获取逻辑, 因为只有失败才会下一步，所以 promise 反着用，成功了 reject 失败了 fullfill。获取用户密码除外
///    1. 读取缓存
///    2. 读取缓存失败
///    2. 读取服务器缓存
///    3. 读取服务器缓存失败
///    3. 登录教务系统
///    4. 登录教务系统失败
///    5. 教务系统获取课表
///    6. 教务系统获取课表失败
///    7. 信息门户获登录
///    8. 信息门户获登录失败
///    9. 教务系统获取课表
///    10. 教务系统获取课表失败
///    11. 提示错误信息
class HFParseVidewModel {
    typealias UserInfo = (sid: String, school: Int, jwpass: String?, mhpass: String?)
    
    var info: UserInfo?
    
    func fetchSchedule(for week: Int, completion: @escaping ((_ models: [CourseDayModel], _ error: String?) -> Void)) {
        // 成功失败颠倒
        HFCourseModel.read(for: week)
            .then { Void -> Promise<Void> in
                return self.fetchScheduleFromServer()
            }.then { Void -> Void in
                // 如果刷新则调用这个
                self.refreshSchedule(for: week, completion: completion)
            }.catch { error in
                if error.isFullfill {
                    let result = HFCourseModel.readCourses(forWeek: week) ?? []
                    completion(result, nil)
                } else {
                    completion([], error.description)
                }
        }
    }
    
    func refreshSchedule(for week: Int, completion: @escaping ((_ models: [CourseDayModel], _ error: String?) -> Void)) {
        self.fetchUserPassword().then { Void -> Promise<Void> in
            // 读取到用户的教务和信息门户密码后~~
            return self.fetchScheduleFromJW()
            } .then { Void -> Void in
                
            }.catch { error in
                if error.isFullfill {
                    let result = HFCourseModel.readCourses(forWeek: week) ?? []
                    completion(result, nil)
                } else {
                    completion([], error.description)
                }
        }
        
        
    }
    
    func fetchScheduleFromServer() -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            HFBaseRequest.fire(api: "/api/schedule/schedule", response: { (json, error) in
                if let error = error {
                    Logger.error("获取服务器缓存失败 | \(error)")
                    fullfill()
                } else {
                    if let array = json["data"].string?.jsonToArray() {
                        PlistManager.dataPlist.saveValues([PlistKey.ScheduleList.rawValue: array])
                        Logger.debug("获取服务器缓存成功")
                        reject(HFParseError.fullfill)
                    } else {
                        Logger.error("服务器缓存读取数据格式错误 | \(json)")
                        fullfill()
                    }
                }
            })
        }
    }
    
    /// 成功才能继续
    func fetchUserPassword() -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            if let _ = info {
                fullfill()
            } else {
                Logger.debug("正在从服务器获取用户信息")
                HFBaseRequest.fire(api: "/api/user/bindingInfo",
                                   method: .GET,
                                   response: { (json, error) in
                                    if let error = error {
                                        Logger.error(error)
                                        reject(HFParseError.suspend(info: error))
                                    } else {
                                        let sid        = json["data"]["sid"].stringValue
                                        let school     = json["data"]["school"].intValue        // 0 合肥；1 宣城
                                        let jwpassword = json["data"]["pwdIMS"].stringValue
                                        let mhpassword = json["data"]["pwdPortal"].stringValue
                                        
                                        let jwpass = jwpassword.DESDecrypt(DataEnv.user!.password.md5())
                                        let mhpass = mhpassword.DESDecrypt(DataEnv.user!.password.md5())
                                        
                                        if jwpass == nil && mhpass == nil {
                                            let error = school == 0 ? "请重新绑定教务系统和信息门户" : "请重新绑定教务系统和信息门户"
                                            Logger.error("从服务器获取用户信息失败，未绑定")
                                            reject(HFParseError.suspend(info: error))
                                        } else {
                                            self.info = (sid, school, jwpass, mhpass)
                                            fullfill()
                                            Logger.debug("获取用户信息成功 | \(sid) \(school) | 教务 \(jwpass ?? "") | 信息门户 \(mhpass ?? "")")
                                        }
                                    }
                })
            }
            
        }
    }
    
    // MARK: 教务系统处理
    func fetchScheduleFromJW() -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            loginToJW()
                .then { Void -> Promise<Data> in
                    self.fetchDataFromWeb(url: EduURL.schedule)
                }.then { data -> Promise<JSONItem> in
                    self.parseData(data: data, with: "/api/schedule/uploadScore")
                }.then { json -> Void in
                    if let array = json["data"].RAW?.jsonToArray() {
                        PlistManager.dataPlist.saveValues([PlistKey.ScheduleList.rawValue: array])
                        Logger.debug("解析数据缓存成功")
                        reject(HFParseError.fullfill)
                    } else {
                        Logger.error("解析后的数据格式错误 | \(json)")
                        fullfill()
                    }
                }.catch { error in
                    fullfill()
            }
        }
    }
    
    
    func loginToJW() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            if let jwpass = info?.jwpass, jwpass != "" {
                
                var request = URLRequest(url: URL(string: EduURL.jwLogin)!)
                request.httpMethod = "POST"
                request.httpBody = "UserStyle=student&user=\(info!.sid)&password=\(jwpass)".data(using: .utf8)
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                HFBaseSession.fire(request: request, redirect: false) { (data, response, error) in
                    if let response = response as? HTTPURLResponse, response.statusCode == 302 {
                        Logger.debug("登录教务系统成功")
                        fulfill()
                    } else {
                        Logger.error("登录教务系统失败 | u=\(self.info!.sid)p=\(jwpass) respose \(response) | error \(error)")
                        reject(HFParseError.loginError)
                    }
                }
            } else {
                Logger.error("登录教务系统失败 | 未绑定 ")
                reject(HFParseError.loginError)
            }
        }
    }
    
    
    /// 从服务器获取 HTTP 数据
    func fetchDataFromWeb(url: String) -> Promise<Data> {
        return Promise<Data> { fulfill, reject in
            Pita.build(HTTPMethod: .GET, url: url)
                .responseData { (data, response) in
                    if let data = data {
                        Logger.debug("获取数据成功")
//                        Logger.verbose(String(data: data, encoding: .gb2312) ?? "")
                        fulfill(data)
                    } else {
                        reject(HFParseError.getHtmlFail)
                    }
            }
        }
    }
    
    /// 上传服务器解析数据
    func parseData(data: Data, with url: String) -> Promise<JSONItem> {
        return Promise<JSONItem> { fulfill, reject in
            
            let compressedData: Data = try! data.gzipped()
            let file = File(name: "course", data: compressedData, type: "html")
            Logger.debug("正在上传数据到服务器来解析")
            
            Pita.build(HTTPMethod: .POST, url: APIBaseURL + "/api/schedule/uploadSchedule")
                .addFiles([file])
                .onNetworkError({ (error) in
                    Logger.error("解析失败 \(error.localizedDescription)")
                    reject(HFParseError.suspend(info: error.localizedDescription))
                    return
                })
                .responseJSON({ (json, response) in
                    let success = json["statue"].intValue == 1
                    if success {
                        Logger.debug("解析成功")
                        fulfill(json)
                        return
                    } else {
                        Logger.error("解析失败 \(json["info"].stringValue)")
                        reject(HFParseError.suspend(info: "解析数据失败"))
                        return
                    }
                })
        }
    }
    
    
}



/// 可以禁止重定向的请求
class HFBaseSession: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
    
    static func fire(request: URLRequest, redirect: Bool, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var delegate: HFBaseSession? = nil
        if !redirect {
            delegate = HFBaseSession()
        }
        
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        session.dataTask(with: request, completionHandler: completion).resume()
        
    }
}
