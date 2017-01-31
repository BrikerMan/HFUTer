//
//  HFAPIRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/1/31.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Pitaya

typealias JSONItem = JSONND
typealias PitaHTTPMethod = HTTPMethod

class HFAPIRequest {
    var manager: HFAPIRequestManager!
    
    static func build(api: String, method: PitaHTTPMethod = PitaHTTPMethod.POST, param: JSON = JSON()) -> HFAPIRequest {
        let r = HFAPIRequest()
        r.manager = HFAPIRequestManager(api:api ,method: method, param: param)
        return r
    }
    
    func response(callback: ((_ json: JSONItem, _ error: String?, _ isNetError: Bool) -> Void)?) {
        self.manager.response(callback: callback)
    }
    
}

class HFAPIRequestManager {
    var api = ""
    var method = PitaHTTPMethod.POST
    var param: JSON = JSON()
    
    init(api: String, method: PitaHTTPMethod, param: JSON = JSON()) {
        self.method = method
        self.param  = param
    }
    
    func response(callback: ((_ json: JSONItem, _ error: String?, _ isNetError: Bool) -> Void)?) {
        let url = APIBaseURL + api 
        log.infoLog("| FLBaseRequest | fire request @ \(api) | params: \n \(param)")
        
        Pita.build(HTTPMethod: .POST, url: url)
            .addParams(param)
            .setHTTPHeader(Name: "Cookie", Value: DataEnv.token)
            .onNetworkError({ (error) in
                callback?(JSONND(),error.localizedDescription, true)
            })
            .responseJSON { (json, response) in
                print(json)
                if json["status"].intValue == 200 {
                    callback?(json["data"], nil, false)
                } else {
                    callback?(JSONND(),json["error_msg"].string ?? "服务器为返回错误信息", false)
                }
        }
    }
}
