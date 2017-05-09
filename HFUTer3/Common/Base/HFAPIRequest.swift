//
//  HFAPIRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/1/31.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Pitaya
import PromiseKit

typealias PitaHTTPMethod = HTTPMethod
typealias JSON = [String: Any]

enum HFAPIRequestError: Error {
    case netError
    case jsonError
    case serverError(info: String)
    
    func decs() -> String {
        switch self {
        case .netError:
            return "网络错误，请稍候再试"
        case .jsonError:
            return "数据格式错误，请联系开发者"
        case .serverError(let info):
            return info
        }
    }
}


extension Error {
    var hfDescription: String {
        if let error = self as? HFAPIRequestError {
            return error.decs()
        } else {
            return self.localizedDescription
        }
    }
}

class HFAPIRequest {
    var manager: HFAPIRequestManager!
    
    static func build(api: String, method: PitaHTTPMethod = PitaHTTPMethod.POST, param: JSON = JSON()) -> HFAPIRequest {
        let r = HFAPIRequest()
        r.manager = HFAPIRequestManager(api:api ,method: method, param: param)
        return r
    }
    
    static func buildPromise(api: String, method: PitaHTTPMethod = PitaHTTPMethod.POST, param: JSON = JSON()) -> Promise<JSONItem> {
        return Promise<JSONItem> { fullfill, reject in
            HFAPIRequestManager(api:api ,method: method, param: param)
                .response(callback: { (json, error) in
                    if let error = error {
                        reject(error)
                    } else {
                        fullfill(json)
                    }
                })
        }
    }
    
    func response(callback: ((_ json: JSONItem, _ error: HFAPIRequestError?) -> Void)?) {
        self.manager.response(callback: callback)
    }
}

class HFAPIRequestManager {
    var api = ""
    var method = PitaHTTPMethod.POST
    var param: JSON = JSON()
    
    init(api: String, method: PitaHTTPMethod, param: JSON = JSON()) {
        self.api    = api
        self.method = method
        self.param  = param
    }
    
    func response(callback: ((_ json: JSONItem, _ error: HFAPIRequestError?) -> Void)?) {
        if api != "api/user/login" {
            HFCookieRequest.update()
                .then {
                    self.fire(callback: callback)
                }.catch { error in
                   callback?(JSONItem(), error as? HFAPIRequestError)
            }
        } else {
            self.fire(callback: callback)
        }
    }
    
    func fire(callback: ((_ json: JSONItem, _ error: HFAPIRequestError?) -> Void)?) {
        let url = APIBaseURL + "/" + api
        
        Logger.verbose("fire request \(url) param: \(param)")
        
        Pita.build(HTTPMethod: .POST, url: url)
            .addParams(param)
            .setHTTPHeader(Name: "Cookie", Value: DataEnv.token)
            .onNetworkError({ (error) in
                callback?(JSONND(), HFAPIRequestError.netError)
                Logger.error(HFAPIRequestError.netError.decs())
            })
            .responseJSON { (json, response) in
                if json["statue"].intValue == 1 {
                    if let headers = response?.allHeaderFields {
                        DataEnv.saveToken(headers)
                    }
                    callback?(json["data"], nil)
                } else {
                    let errorInfo = json["error_msg"].string ?? "服务器未返回错误信息"
                    callback?(JSONND(), HFAPIRequestError.serverError(info: errorInfo))
                    Logger.error(errorInfo)
                }
        }

    }
}
