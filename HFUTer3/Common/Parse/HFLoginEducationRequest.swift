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

typealias FaiedBlock    = (_ error: String) -> Void
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
    
    static func fetchSchedule() {
        getUserPassword()
            .then { info -> Promise<Bool> in
                return login(info: info)
            }.then { result -> Void in
                print(result)
            }.catch { error in
                print(error.localizedDescription)
        }
    }
    
    typealias UserInfo = (sid: String, school: Int, jwpass: String?, mhpass: String?)
    static func getUserPassword() -> Promise<UserInfo> {
        return Promise<UserInfo> { fulfill, reject in
            HFBaseRequest.fire(api: "/api/user/bindingInfo",
                               method: .GET,
                               response: { (json, error) in
                                if let error = error {
                                    Logger.error(error)
                                    reject(EduRequestError.otherError(info: error))
                                } else {
                                    let sid        = json["data"]["sid"].stringValue
                                    let school     = json["data"]["school"].intValue
                                    let jwpassword = json["data"]["pwdPortal"].stringValue
                                    let mhpassword = json["data"]["pwdIMS"].stringValue
                                    
                                    let jwpass = decrypt(jwpassword)
                                    let mhpass = decrypt(mhpassword)
                                    self.host = school == 0 ? EduURL.hfhost : EduURL.xchost
                                    
                                    fulfill((sid, school, jwpass, mhpass))
                                    Logger.debug("| 获取用户信息成功 | \(sid) \(school) | 教务 \(jwpass ?? "") | 信息门户 \(mhpass ?? "")")
                                }
            })
        }
    }
    
    static func login(info: UserInfo) -> Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            if hasLogin {
                fulfill(true)
                return
            }
            
            if let jwpass = info.jwpass {
                let url = host + EduURL.login
                Pita.build(HTTPMethod: .POST, url: url)
                    .setHTTPHeader(Name: "Content-Type", Value: "application/x-www-form-urlencoded")
                    .setHTTPBodyRaw("UserStyle=student&user=\(info.sid)&password=\(jwpass)")
                    .onNetworkError({ (error) in
                        reject(error)
                    })
                    .responseData { (data, response) in
                        if let data = data {
                            let str = String(data: data, encoding: .gb2312) ?? ""
                            if str.contains("密码验证") {
                                reject(EduRequestError.passwordError)
                            } else {
                                hasLogin = true
                                fulfill(true)
                            }
                        } else {
                            reject(EduRequestError.netError)
                        }
                }
                return
            }
            
            if let mhpass = info.mhpass {
                print(mhpass)
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
