//
//  HFBaseRequest.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import AlamofireDomain

let RequestPage = "pageIndex"


/// 请求结果闭包
///
/// - Parameters:
///   - response: 请求结果
///   - error: 错误信息
typealias HFBaseRequestResponse = (_ response: JSONItem, _ error:String?)->Void

class HFBaseRequest {
    
    
    /// 发送请求
    ///
    /// - Parameters:
    ///   - api: api 名称
    ///   - method: HTTP Method
    ///   - params: 请求参数
    ///   - response: 请求结果
    class func fire(api:String,
                    method: HFBaseAPIRequestMethod = .POST,
                    params: HFRequestParam = HFRequestParam(),
                    response:((_ response: JSONItem, _ error:String?)->Void)?) {
         let baserequest = HFBaseRequest()
        baserequest.requestWithParams(api: api,
                                      method: method,
                                      params: params,
                                      response: response)
    }
    
    fileprivate func requestWithParams(api:String,
                                       method: HFBaseAPIRequestMethod,
                                       params: HFRequestParam,
                                       response:((_ response: JSONItem, _ error:String?)->Void)?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let headers:[String:String] = ["Cookie":DataEnv.token]
        
        
        var requestMethod = HTTPMethod.get
        switch method {
        case .GET:
            requestMethod = HTTPMethod.get
        case .POST:
            requestMethod = HTTPMethod.post
        }
        
        log.infoLog("Send \(method.rawValue) Request - url : \(api)", params: [params], withFuncName: false)
        
        AlamofireDomain.request(APIBaseURL + api, method: requestMethod, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseJSON { result in
               self.resultHandler(result, response: response)
        }
    }
    
    
    

    fileprivate func resultHandler(_ requestResponse: DataResponse<Any>,
                                   response:((_ response: JSONItem, _ error:String?)->Void)?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        log.infoLog("Received Response", params: [requestResponse], withFuncName: false)
        
        // 若有token返回，则刷新token
        if let headers = requestResponse.response?.allHeaderFields {
            DataEnv.saveToken(headers)
        }
        
        
        
        switch requestResponse.result.isSuccess {
        case true:
            
            if let resultDic = requestResponse.result.value as? [String:AnyObject],
                let statue = resultDic["statue"] as? Bool {
                if statue == true {
                    response?(JSONItem(dictionary: resultDic), nil)
                    return
                } else {
                    let errorInfo = resultDic["info"] as? String  ?? "服务器未返回错误信息"
                    response?(JSONItem(), errorInfo)
                }
            } else {
                let errorInfo = "数据格式错误啊喂"
                response?(JSONItem(), errorInfo)
            }
        case false:
            var errorInfo = ""
            if let resultDic = requestResponse.result.value as? [String:AnyObject],
                let error = resultDic["info"] as? String {
                errorInfo = error
            } else {
                errorInfo = "网络错误了"
            }
            response?(JSONItem(), errorInfo)
        }
    }
    
    


    
    fileprivate func urlRequestWithComponents(_ urlString:String, parameters:HFRequestParam, imageData:(name:String,data: Data)?) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest =  URLRequest(url:URL(string: urlString)!)
        mutableURLRequest.httpMethod = HTTPMethod.post.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        if let imageData = imageData {
            // add image
            uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(imageData.name)\"\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append(imageData.data as Data)
        }
        // add parameters
        for (key, value) in parameters {
            uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
        }
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        // return URLRequestConvertible and NSData
        return (try! URLEncoding.default.encode(mutableURLRequest, with: nil), uploadData)
    }
    
    // MARK: - 弃用方法
    class func fire(_ apiURL:String,
                    image:(name:String,data: Data)? = nil,
                    method: HFBaseAPIRequestMethod = .POST,
                    params: HFRequestParam = HFRequestParam(),
                    succesBlock:((_ request: HFBaseRequest, _ resultDic:HFRequestParam)->Void)?,
                    failBlock:((_ request: HFBaseRequest, _ error:String?)->Void)?) {
        
        let baserequest = HFBaseRequest()
        
        if let image = image {
            baserequest.uploadFileRequestWithParam(apiURL,
                                                   image: image,
                                                   params: params,
                                                   succesBlock:succesBlock,
                                                   failBlock:failBlock)
        } else {
            baserequest.requestWithParams(apiURL,
                                          method: method,
                                          params: params,
                                          succesBlock:succesBlock,
                                          failBlock:failBlock)
        }
    }
    
    fileprivate func requestWithParams(_ apiURL:String,
                                       method: HFBaseAPIRequestMethod = .POST,
                                       params: HFRequestParam = HFRequestParam(),
                                       succesBlock:((_ request: HFBaseRequest, _ resultDic:HFRequestParam)->Void)?,
                                       failBlock:((_ request: HFBaseRequest, _ error:String?)->Void)?)  {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        let headers:[String:String] = ["Cookie":DataEnv.token]
        
        
        var requestMethod = HTTPMethod.get
        switch method {
        case .GET:
            requestMethod = HTTPMethod.get
        case .POST:
            requestMethod = HTTPMethod.post
        }
        
        log.infoLog("Send \(method.rawValue) Request - url : \(apiURL)", params: [params], withFuncName: false)
        
        AlamofireDomain.request(APIBaseURL + apiURL, method: requestMethod, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                self.resultHandler(response,
                                   succesBlock: succesBlock,
                                   failBlock: failBlock)
        }
    }
    
    fileprivate func uploadFileRequestWithParam(_ apiURL:String,
                                                image: (name:String,data: Data)?,
                                                params: HFRequestParam = HFRequestParam(),
                                                succesBlock:((_ request: HFBaseRequest, _ resultDic:HFRequestParam)->Void)?,
                                                failBlock:((_ request: HFBaseRequest, _ error:String?)->Void)?) {
        
        
        let host = APIBaseURL + apiURL
        
        let urlRequest = urlRequestWithComponents(host, parameters: params, imageData:(image))
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        AlamofireDomain.upload(urlRequest.1 as Data, with: urlRequest.0)
            .responseJSON(completionHandler: { (response) in
                self.resultHandler(response,
                                   succesBlock: succesBlock,
                                   failBlock: failBlock)
            })
    }
    
    fileprivate func resultHandler(_ response: DataResponse<Any>,
                                   succesBlock:((_ request: HFBaseRequest, _ resultDic:HFRequestParam)->Void)?,
                                   failBlock:((_ request: HFBaseRequest, _ error:String?)->Void)?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        log.infoLog("Received Response", params: [response], withFuncName: false)
        
        // 若有token返回，则刷新token
        if let headers = response.response?.allHeaderFields {
            DataEnv.saveToken(headers)
        }
        
        switch response.result.isSuccess {
        case true:
            if let resultDic = response.result.value as? [String:AnyObject], let statue = resultDic["statue"] as? Bool {
                if statue == true {
                    succesBlock?(self ,resultDic)
                    return
                } else {
                    let errorInfo = resultDic["info"] as? String  ?? "服务器未返回错误信息"
                    failBlock?(self ,errorInfo)
                }
            } else {
                let errorInfo = "数据格式错误啊喂"
                failBlock?(self ,errorInfo)
            }
        case false:
            var errorInfo = ""
            if let resultDic = response.result.value as? [String:AnyObject], let error = resultDic["info"] as? String {
                errorInfo = error
            } else {
                errorInfo = "网络错误了"
            }
            failBlock?(self ,errorInfo)
        }
    }
}
