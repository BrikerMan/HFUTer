//
//  HFUpdateCookieRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/17.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import AlamofireDomain
import PromiseKit
import Pitaya

class HFCookieRequest {
    @discardableResult
    static func update() -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            guard let username = DataEnv.user?.sid, let password = DataEnv.user?.password, DataEnv.isLogin else {
                Logger.error("木有保存用户名密码")
                fullfill(())
                return
            }
            
            if Date().timeIntervalSince1970 - DataEnv.updateTokenDate.timeIntervalSince1970 < 3600 {
                Logger.warning("不需要更新 token， 时间未到")
                fullfill(())
                return
            }
            
            Logger.info("开始更新 Token")
            login(username: username, password: password)
                .then {
                    fullfill(())
                }.catch { error in
                    reject(error)
            }
        }
    }
    
    static func login(username: String, password: String) -> Promise<Void> {
        return Promise<Void> { fullfill, reject in
            HFAPIRequest.buildPromise(api: "api/user/login",
                                      method: .GET,
                                      param: ["sid":username, "pwd":password, "auto_rebound": true])
                .then { _ in
                    fullfill(())
                }.catch { error in
                    reject(error)
            }
            
        }
    }
    
//@available(*, deprecated)
//func checkUpdate(onSucces succes:(()->Void)?, failed:((_ error:String)->Void)?) {
//    if DataEnv.isLogin && !DataEnv.hasUpdateToken {
//        if let username = DataEnv.user?.sid, let password = DataEnv.user?.password {
//            
//            if password == "" {
//                //                    log.errorLog("没有保存用户名密码啊喂", params:[] )
//                failed?("")
//                return
//            }
//            
//            let params: JSON = ["sid":username, "pwd": password.md5()]
//            let url =  APIBaseURL + "/api/user/login"
//            //                log.infoLog("******更新Token请求******", params: [params])
//            AlamofireDomain.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: nil)
//                .responseJSON { response in
//                    switch response.result.isSuccess {
//                    case true:
//                        // 如果登陆成功，则刷新Token并标志一下，下次直接走成功回调
//                        // 如果失败则调用失败回调，显示登陆界面，重新登录。这个时候按照用户退出处理，清空数据。状态改为登出。
//                        if let resultDic = response.result.value as? [String:AnyObject], let statue = resultDic["statue"] as? Bool ,let headers = response.response?.allHeaderFields {
//                            if statue == true {
//                                // 若有token返回，则刷新token
//                                DataEnv.saveToken(headers)
//                                succes?()
//                            } else {
//                                let errorInfo = resultDic["info"] as? String  ?? ""
//                                failed?(errorInfo)
//                                //                                    log.errorLog(errorInfo)
//                            }
//                        } else {
//                            let errorInfo = "数据格式错误啊喂"
//                            failed?(errorInfo)
//                            //                                log.errorLog(errorInfo, params: [response.request?.allHTTPHeaderFields ?? "",response.response?.allHeaderFields ?? "",response.result.value ?? ""])
//                        }
//                    case false:
//                        if let resultDic = response.result.value as? [String:AnyObject], let error = resultDic["info"] as? String {
//                            failed?(error)
//                            //                                log.errorLog(error, params: [response.request?.allHTTPHeaderFields ?? "",response.response?.allHeaderFields ?? "",response.result.value ?? ""])
//                        } else {
//                            let errorInfo = "数据格式错误啊喂"
//                            failed?(errorInfo)
//                            //                                log.errorLog(errorInfo, params: [response.request?.allHTTPHeaderFields ?? "",response.response?.allHeaderFields ?? "",response.result.value ?? ""])
//                        }
//                    }
//            }
//        } else {
//            //                log.errorLog("没有保存用户名密码啊喂", params:[] )
//            failed?("")
//        }
//    } else {
//        succes?()
//    }
//}
}
