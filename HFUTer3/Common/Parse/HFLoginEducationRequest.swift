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
import PromiseKit

typealias FaiedBlock        = (_ error: String) -> Void
typealias ProgressBlock = (_ progress: String) -> Void

enum EduRequestError: Error {
    case netError
    case passwordError
    case otherError(info: String)
}

enum EduRequestType: String {
    case grade    = "/api/schedule/uploadScore"
    case schedule = "/api/schedule/uploadSchedule"
}

class HFEducationRequest {
    
    static var host     = EduURL.xchost
    static var hasLogin = false
    
    static func getSchedule(progress: @escaping ProgressBlock,
                            success:  @escaping (_ result: JSONItem) -> Void,
                            failed:   @escaping FaiedBlock) {
        progress("开始登录 ...")
        getUserPassword().then { info -> Void in
            print(info.sid)
            print(info.school)
            print(info.jwpassword)
            print(info.mhpassword)
            
            print("CODEEEEEEE " + (decrypt(info.jwpassword) ?? "| 解密失败 | \(info.jwpassword) | \(DataEnv.user!.password) |"))
            print("CODEEEEEEE " + (decrypt(info.mhpassword) ?? "| 解密失败 | \(info.mhpassword) | \(DataEnv.user!.password) |"))
            
            host = info.school == 0 ? EduURL.hfhost : EduURL.xchost
            }.catch{ (error) -> Void in
                print(error)
                
        }
        
//        login()
//            .then { success -> Promise<Data> in
//                progress("登录成功")
//                progress("从教务系统获取数据 ...")
//                let url = host + EduURL.schedule
//                return getDataFromWeb(url: url)
//            }.then { data -> Promise<JSONItem> in
//                progress("开始解析 ...")
//                return parseData(data: data, with: APIBaseURL + "/api/schedule/uploadSchedule")
//            }.then { json -> Void in
//                progress("获取解析数据成功")
//                success(json)
//            }.catch { (error) -> Void in
//                print("===========错误 \(error)")
//        }
    }
    
    static func getGrades(progress:  @escaping ProgressBlock,
                            success: @escaping (_ result: JSONItem) -> Void,
                            failed:  @escaping FaiedBlock) {
        progress("开始登录 ...")
        login()
            .then { success -> Promise<Data> in
                progress("登录成功")
                progress("从教务系统获取数据 ...")
                let url = host + EduURL.score
                return getDataFromWeb(url: url)
            }.then { data -> Promise<JSONItem> in
                progress("开始解析 ...")
                return parseData(data: data, with: APIBaseURL + "/api/schedule/uploadScore")
            }.then { json -> Void in
                progress("获取解析数据成功")
                success(json)
            }.catch { (error) -> Void in
                print("===========错误 \(error)")
        }
    }

    typealias UserInfo = (sid: String, school: Int, jwpassword: String, mhpassword: String )
    static func getUserPassword() -> Promise<UserInfo> {
        return Promise<UserInfo> { fulfill, reject in
            HFBaseRequest.fire(api: "/api/user/bindingInfo",
                               method: .GET,
                               response: { (json, error) in
                                if let error = error {
                                    reject(EduRequestError.otherError(info: error))
                                } else {
                                    let sid        = json["data"]["sid"].stringValue
                                    let school     = json["data"]["sid"].intValue
                                    let jwpassword = json["data"]["pwdPortal"].stringValue
                                    let mhpassword = json["data"]["pwdIMS"].stringValue
                                
                                    fulfill((sid, school, jwpassword, mhpassword))
                                }
            })
        }
    }
    
    static func login() -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            if hasLogin {
                fulfill(true)
            }
            let url = host + EduURL.login
            Pita.build(HTTPMethod: .POST, url: url)
                .setHTTPHeader(Name: "Content-Type", Value: "application/x-www-form-urlencoded")
                .setHTTPBodyRaw("UserStyle=student&user=2015218508&password=824fc699")
                .responseData { (data, response) in
                    if let data = data {
                        let str = String(data: data, encoding: .gb2312) ?? ""
                        if str.contains("密码验证") {
                            return reject(EduRequestError.passwordError)
                        } else {
                            hasLogin = true
                            return fulfill(true)
                        }
                    } else {
                        return reject(EduRequestError.netError)
                    }
            }
        }
    }
    
    /// 从服务器获取 HTTP 数据
    static func getDataFromWeb(url: String) -> Promise<Data> {
        return Promise<Data> { fulfill, reject in
            Pita.build(HTTPMethod: .GET, url: url)
                .responseData { (data, response) in
                    if let data = data {
                        fulfill(data)
                    } else {
                        
                    }
            }
        }
    }
    
    static func parseData(data: Data, with url: String) -> Promise<JSONItem> {
        return Promise<JSONItem> { fulfill, reject in
            
            let compressedData: Data = try! data.gzipped()
            let file = File(name: "course", data: compressedData, type: "html")
            
            
            Pita.build(HTTPMethod: .POST, url: url)
                .addFiles([file])
                .onNetworkError({ (error) in
                    return reject(EduRequestError.netError)
                })
                .responseJSON({ (json, response) in
                    let success = json["statue"].intValue == 1
                    if success {
                        return fulfill(json)
                    } else {
                        return reject(EduRequestError.netError)
                    }
                })
        }
    }

    
    static func decrypt(_ original: String) -> String? {
        let doceded = original.DESDecrypt(DataEnv.user!.password.md5())
        return doceded
    }
    
}


extension String {
    func DESDecrypt(_ key: String) -> String? {
        return DESEncryption.decryptUseDES(self, key: key)
    }
}

extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, characters.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else {
            return nil
        }
        
        return data
    }
}

extension String {
    
    /// Create `String` representation of `Data` created from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a String object from that. Note, if the string has any spaces, those are removed. Also if the string started with a `<` or ended with a `>`, those are removed, too.
    ///
    /// For example,
    ///
    ///     String(hexadecimal: "<666f6f>")
    ///
    /// is
    ///
    ///     Optional("foo")
    ///
    /// - returns: `String` represented by this hexadecimal string.
    
    init?(hexadecimal string: String) {
        guard let data = string.hexadecimal() else {
            return nil
        }
        
        self.init(data: data, encoding: .utf8)
    }
    
    /// Create hexadecimal string representation of `String` object.
    ///
    /// For example,
    ///
    ///     "foo".hexadecimalString()
    ///
    /// is
    ///
    ///     Optional("666f6f")
    ///
    /// - parameter encoding: The `NSStringCoding` that indicates how the string should be converted to `NSData` before performing the hexadecimal conversion.
    ///
    /// - returns: `String` representation of this String object.
    
    func hexadecimalString() -> String? {
        return data(using: .utf8)?
            .hexadecimal()
    }
    
}

extension Data {
    
    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.
    
    func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}
