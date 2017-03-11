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

enum HFParseServerType: String {
    case jw = "教务系统"
    case mh = "信息门户"
}


enum HFParseViewModelDataType {
    case schedule
    case grades
}

/*
 ##课表获取逻辑, 因为只有失败才会下一步，所以 promise 反着用，成功了 reject 失败了 fullfill。获取用户密码除外
 1. 读取缓存
 2. 读取缓存失败
 3. 读取服务器缓存
 4. 读取服务器缓存失败
 5. 登录教务系统
 6. 登录教务系统失败
 7. 教务系统获取课表
 8. 教务系统获取课表失败
 9. 上传服务器并解析成功
 9. 信息门户获登录
 10. 信息门户获登录失败
 11. 教务系统获取课表
 12. 教务系统获取课表失败
 13. 上传服务器并解析成功
 13. 提示错误信息
 
 其中服务器缓存，教务系统和信息门户，如果前一个获取或者解析失败，则进行下一个请求，成功就返回。如果三个来源都均不能获取，则提示错误信息
 */
class HFParseViewModel {
    typealias UserInfo = (sid: String, school: Int, jwpass: String?, mhpass: String?)
    
    static var info: UserInfo?
    /// 数据类型，成绩的话需要修改
    var dataType = HFParseViewModelDataType.schedule
    
    // 读取课表
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
    
    // 刷新课表数据
    func refreshSchedule(for week: Int, completion: @escaping ((_ models: [CourseDayModel], _ error: String?) -> Void)) {
        self.refreshData { (error) in
            let result = HFCourseModel.readCourses(forWeek: week) ?? []
            completion(result, error)
        }
    }
    
    func fetchGrades(completion: @escaping ((_ models: [HFTermModel], _ error: String?) -> Void)) {
        if let result = HFTermModel.readModels() {
            completion(result, nil)
        } else {
            self.refreshGrades(completion: completion)
        }
    }
    
    func refreshGrades(completion: @escaping ((_ models: [HFTermModel], _ error: String?) -> Void)) {
        self.refreshData { (error) in
            let result = HFTermModel.readModels() ?? []
            completion(result, error)
        }
    }
    
    fileprivate func refreshData(completion: @escaping ((_ error: String?) -> Void)) {
        self.fetchUserPassword()
            .then { Void -> Promise<Void> in
                // 读取到用户的教务和信息门户密码后~~
                return self.fetchNewData(from: .jw)
            } .then { Void -> Promise<Void> in
                return self.fetchNewData(from: .mh)
            }.then { Void -> Void in
                completion("教务系统和信息门户密码错误或过期，请重新绑定")
            }.catch { error in
                if error.isFullfill {
                    completion(nil)
                } else {
                    completion(error.description)
                }
        }
        
    }
    
    // 获取服务器缓存的课表
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
    
    /// 获取用户信息
    fileprivate func fetchUserPassword() -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            if let _ = HFParseViewModel.info {
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
                                        
                                        EduURL.school = school
                                        
                                        let jwpass = jwpassword.DESDecrypt(DataEnv.user!.password.md5())
                                        let mhpass = mhpassword.DESDecrypt(DataEnv.user!.password.md5())
                                        
                                        if jwpass == nil && mhpass == nil {
                                            let error = school == 0 ? "请重新绑定教务系统和信息门户" : "请重新绑定教务系统和信息门户"
                                            Logger.error("从服务器获取用户信息失败，未绑定")
                                            reject(HFParseError.suspend(info: error))
                                        } else {
                                            HFParseViewModel.info = (sid, school, jwpass, mhpass)
                                            fullfill()
                                            Logger.debug("获取用户信息成功 | \(sid) \(school) | 教务 \(jwpass ?? "") | 信息门户 \(mhpass ?? "")")
                                        }
                                    }
                })
            }
            
        }
    }
    
    // MARK: - 登录
    fileprivate func login(to type: HFParseServerType) -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            var pass : String
            var url  : String
            switch type {
            case .jw:
                url  = EduURL.jwLogin
                pass = HFParseViewModel.info?.jwpass ?? ""
            case .mh:
                url  = EduURL.mhLogin
                pass = HFParseViewModel.info?.mhpass ?? ""
                // TODO: - remove this
                pass = "ZYL6297035"
            }
            
            if pass != "" {
                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "POST"
                switch type {
                case .jw:
                    request.httpBody = "UserStyle=student&user=\(DataEnv.user!.sid)&password=\(pass)".data(using: .utf8)
                case .mh:
                    request.httpBody = "IDToken0=&IDToken1=\(DataEnv.user!.sid)&IDToken2=\(pass)&IDButton=Submit&goto=&encoded=false&inputCode=&gx_charset=UTF-8".data(using: .utf8)
                }
                
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                HFBaseSession.fire(request: request, redirect: false) { (data, response, error) in
                    if let response = response as? HTTPURLResponse, response.statusCode == 302 {
                        Logger.debug("登录\(type.rawValue)成功")
                        
                        switch type {
                        case .jw:
                            Logger.debug("登录\(type.rawValue)成功")
                            fulfill()
                        case .mh:
                            // 信息门户跳转教务系统需要拿着用户获取的 cookie 去拉一下数据
                            //                            let cookie = self.parseCookie(response.allHeaderFields)
                            var req = URLRequest(url: URL(string: "http://bkjw.hfut.edu.cn/StuIndex.asp")!)
                            //                            req.addValue(cookie, forHTTPHeaderField: "Cookie")
                            req.httpMethod = "GET"
                            HFBaseSession.fire(request: req, redirect: false) { (data, response, error) in
                                if let response = response as? HTTPURLResponse, response.statusCode == 302 {
                                    Logger.debug("跳转教务系统成功")
                                    fulfill()
                                } else {
                                    reject(HFParseError.loginError)
                                }
                            }
                        }
                    } else {
                        Logger.error("登录\(type.rawValue)失败 | u=\(DataEnv.user!.sid)p=\(pass) respose \(response) | error \(error)")
                        reject(HFParseError.loginError)
                    }
                }
            } else {
                Logger.error("登录\(type.rawValue)失败 | 未绑定 ")
                reject(HFParseError.loginError)
            }
        }
    }
    
    
    // MARK: 从网页获取数据
    fileprivate func fetchNewData(from type: HFParseServerType) -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            login(to: type)
                .then { Void -> Promise<Data> in
                    self.fetchDataFromWeb()
                }.then { data -> Promise<JSONItem> in
                    self.parseData(data: data)
                }.then { json -> Void in
                    if let array = json["data"].RAW?.jsonToArray() {
                        let key: String
                        switch self.dataType {
                        case .schedule:
                            key = PlistKey.ScheduleList.rawValue
                        case.grades:
                            key = PlistKey.GradesList.rawValue
                        }
                        PlistManager.dataPlist.saveValues([key: array])
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
    
    
    
    /// 从服务器获取 HTTP 数据
    fileprivate func fetchDataFromWeb() -> Promise<Data> {
        let url: String
        switch dataType {
        case .schedule:
            url = EduURL.schedule
        case.grades:
            url = EduURL.score
        }
        
        return Promise<Data> { fulfill, reject in
            Pita.build(HTTPMethod: .GET, url: url)
                .onNetworkError({ (error) in
                    reject(error)
                })
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
    fileprivate func parseData(data: Data) -> Promise<JSONItem> {
        return Promise<JSONItem> { fulfill, reject in
            let fileName : String
            let url      : String
            var newData  : Data
            
            switch dataType {
            case .schedule:
                fileName = "course"
                url      = APIBaseURL + "/api/schedule/uploadSchedule"
                newData  = data
            case.grades:
                fileName  = "score"
                url       = APIBaseURL + "/api/score/uploadScore"
                newData  = String(data: data, encoding: .gb2312)?.data(using: .utf8) ?? data
            }
            
            let compressedData: Data = try! newData.gzipped()
            let file = File(name: fileName, data: compressedData, type: "html")
            
            Logger.debug("正在上传数据到服务器来解析")
            
            Pita.build(HTTPMethod: .POST, url: url)
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
                        let html = String(data: data, encoding: .gb2312)?.trimmed()
                        Logger.error(html ?? "")
                        reject(HFParseError.suspend(info: "解析数据失败"))
                        return
                    }
                })
        }
    }
    
    
    fileprivate func parseCookie(_ headers: [AnyHashable: Any]) -> String{
        var cookie = ""
        if let tokenString = headers["Set-Cookie"] as? String {
            for result in tokenString.matchesForRegexInText("(^| )([a-z]|[A-Z])*=(.*?)(;)") {
                cookie.append(result)
            }
        }
        return cookie
    }
    
}


extension String {
    func DESDecrypt(_ key: String) -> String? {
        return DESEncryption.decryptUseDES(self, key: key)
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
