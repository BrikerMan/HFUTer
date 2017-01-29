//
//  HFUpdateCookieRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/17.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import AlamofireDomain
import Pitaya

class HFUpdateCookieRequest {
    
    static func update(onSucces succes:(()->Void)?, failed:((_ error:String)->Void)?) {
//        if let username = DataEnv.user?.sid, let password = DataEnv.user?.password {
//            
//            if password == "" {
//                log.errorLog("没有保存用户名密码啊喂", params:[] )
//                failed?("")
//                return
//            }
//            
//            let param: JSON = ["sid":username, "pwd": password.md5()]
//            log.infoLog("******更新Token请求******", params: [param])
//            Pita.build(HTTPMethod: .POST, url: APIBaseURL + "/api/user/login")
//                .addParams(param)
//                .responseJSON({ (json, response) in
//                    print(response)
//                    print(json)
//                })
//        }
        
    }
    
    func checkUpdate(onSucces succes:(()->Void)?, failed:((_ error:String)->Void)?) {
        if DataEnv.isLogin && !DataEnv.hasUpdateToken {
            if let username = DataEnv.user?.sid, let password = DataEnv.user?.password {
                
                if password == "" {
                    log.errorLog("没有保存用户名密码啊喂", params:[] )
                    failed?("")
                    return
                }
                
                let params: JSON = ["sid":username, "pwd": password.md5()]
                let url =  APIBaseURL + "/api/user/login"
                log.infoLog("******更新Token请求******", params: [params])
                AlamofireDomain.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: nil)
                    .responseJSON { response in
                        switch response.result.isSuccess {
                        case true:
                            // 如果登陆成功，则刷新Token并标志一下，下次直接走成功回调
                            // 如果失败则调用失败回调，显示登陆界面，重新登录。这个时候按照用户退出处理，清空数据。状态改为登出。
                            if let resultDic = response.result.value as? [String:AnyObject], let statue = resultDic["statue"] as? Bool ,let headers = response.response?.allHeaderFields {
                                if statue == true {
                                    // 若有token返回，则刷新token
                                    DataEnv.saveToken(headers)
                                    succes?()
                                } else {
                                    let errorInfo = resultDic["info"] as? String  ?? ""
                                    failed?(errorInfo)
                                    log.errorLog(errorInfo)
                                }
                            } else {
                                let errorInfo = "数据格式错误啊喂"
                                failed?(errorInfo)
                                log.errorLog(errorInfo, params: [response.request?.allHTTPHeaderFields ?? "",response.response?.allHeaderFields ?? "",response.result.value ?? ""])
                            }
                        case false:
                            if let resultDic = response.result.value as? [String:AnyObject], let error = resultDic["info"] as? String {
                                failed?(error)
                                log.errorLog(error, params: [response.request?.allHTTPHeaderFields ?? "",response.response?.allHeaderFields ?? "",response.result.value ?? ""])
                            } else {
                                let errorInfo = "数据格式错误啊喂"
                                failed?(errorInfo)
                                log.errorLog(errorInfo, params: [response.request?.allHTTPHeaderFields ?? "",response.response?.allHeaderFields ?? "",response.result.value ?? ""])
                            }
                        }
                }
            } else {
                log.errorLog("没有保存用户名密码啊喂", params:[] )
                failed?("")
            }
        } else {
            succes?()
        }
    }
}
