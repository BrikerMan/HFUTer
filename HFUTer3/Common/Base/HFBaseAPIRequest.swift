//
//  HFBaseAPIRequest.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/15.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import AlamofireDomain

enum HFBaseAPIRequestMethod:String {
    case GET  = "GET"
    case POST = "POST"
}


protocol HFBaseAPIManagerCallBack :class{
    func managerApiCallBackSuccess(_ manager:HFBaseAPIManager)
    func managerApiCallBackFailed(_ manager:HFBaseAPIManager)
}

class HFBaseAPIManager {
    weak var callback:HFBaseAPIManagerCallBack?
    
    var request:Request?
    
    /// 用于区分多个请求
    var tag = 0
    /// 回调信息
    var isLoading = false
    var rawData: Data?
    var resultDic = [String:AnyObject]()
    var errorInfo = ""
    
    
    fileprivate var startTime : Date?
    fileprivate var spendTime : TimeInterval = 0.0
    
    /**
     api接口
     */
    func reqeustSubURL() -> String? {
        return nil
    }
    
    /**
     请求类型，默认Post请求
     */
    func reqeustType() -> HFBaseAPIRequestMethod {
        return HFBaseAPIRequestMethod.POST
    }
    
    /**
     默认错误信息
     */
    func errorMessage() -> String? {
        return nil
    }
    
    /**
     请求参数
     */
    func requestParams() -> [String : Any]? {
        return nil
    }
    
    
    /**
     开始加载数据
     */
    func loadData() {
        startTime = Date()
        HFCookieRequest.update()
            .then {
                self.fire()
            }.catch { error in
                Logger.warning(error.hfDescription)
        }
    }
    
    /**
     开始请求
     */
    fileprivate func fire() {
        // 构造请求基本参数
        guard let subURL = reqeustSubURL()
            else { return }
        
        var method = HTTPMethod.get
        
        switch reqeustType() {
        case .GET:
            method = .get
        case .POST:
            method = .post
        }
        
        var paramsDic: JSON = [:]
        if let par = requestParams() {
            paramsDic.update(par)
        }
        
        let headers:[String:String] = ["Cookie":DataEnv.token]
        
//        log.infoLog("Send Request With Param - url : \(subURL)", params: [paramsDic], withFuncName: false)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        request?.cancel()
        
        // 发起请求，顺便把request对象保存起来，以便取消请求。
        request = AlamofireDomain.request(APIBaseURL + subURL, method: method, parameters: paramsDic, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.spendTime = NSDate().timeIntervalSince(self.startTime!)
                
//                log.infoLog("Received Response", params: [response], withFuncName: false)
//                
                // 若有token返回，则刷新token
                if let headers = response.response?.allHeaderFields {
                    DataEnv.saveToken(headers)
                }
                
                switch response.result.isSuccess {
                case true:
                    if let resultDic = response.result.value as? [String:AnyObject] {
                        if let statue = resultDic["statue"] as? Bool {
                            if statue == true {
                                self.rawData = response.data
                                self.resultDic = resultDic
                                self.callback?.managerApiCallBackSuccess(self)
                                return
                            } else {
                                self.errorInfo = resultDic["info"] as? String  ?? ""
                                self.callback?.managerApiCallBackFailed(self)
                            }
                        }
                    } else {
                        self.errorInfo = "数据格式错误啊喂"
                        self.callback?.managerApiCallBackFailed(self)
                    }
                case false:
                    if let resultDic = response.result.value as? [String:AnyObject], let error = resultDic["info"] as? String {
                        self.errorInfo = error
                    } else {
                        self.errorInfo = "网络错误了"
                    }
                    self.callback?.managerApiCallBackFailed(self)
                }
        }
    }
    
    deinit {
        if let _ = startTime {
//            let logStr = String(stringInterpolation:String(describing: self.self), " is released, time spend on this request:\(spendTime) seconds")
//            log.debugLog(logStr, params: [], withFuncName: false)
        } else {
//            let logStr = String(stringInterpolation:String(describing: self.self), " is released without sending request")
//            log.debugLog(logStr, params: [], withFuncName: false)
        }
    }
}
