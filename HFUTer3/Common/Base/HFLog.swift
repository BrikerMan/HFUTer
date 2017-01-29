//
//  HFLog.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

import Crashlytics

enum FMLogLevelEnum:Int {
    case verbose = 0
    case debug   = 1
    case info    = 2
    case error   = 3
}

class FMLogTool {
    static let shared = FMLogTool()
    
    lazy var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    /**
     最详细的log方法。级别最低，用于系统的统一打印。
     */
    func verboseLog(_ mesage:String, params:[Any] = [], withFuncName :Bool = true, filename: String = #file, line: Int = #line, function: String = #function) {
        log(mesage, params: params, withFuncName: withFuncName, level: .verbose, filename: filename, line: line, function: function)
    }
    
    /**
     调试时候需要的log，比如网络请求返回数据，一些数据处理等。
     */
    func debugLog(_ mesage:String, params:[Any] = [], withFuncName :Bool = true, filename: String = #file, line: Int = #line, function: String = #function) {
        log(mesage, params: params,  withFuncName: withFuncName, level: .debug, filename: filename, line: line, function: function)
    }
    
    /**
     比较重要信息的log
     */
    func infoLog(_ mesage:String, params:[Any] = [], withFuncName :Bool = true, filename: String = #file, line: Int = #line, function: String = #function) {
        log(mesage, params: params,  withFuncName: withFuncName, level: .info, filename: filename, line: line, function: function)
    }
    
    /**
     错误log
     */
    func errorLog(_ mesage:String, params:[Any] = [], withFuncName :Bool = true, filename: String = #file, line: Int = #line, function: String = #function) {
        log(mesage, params: params,  withFuncName: withFuncName, level: .error, filename: filename, line: line, function: function)
        HFToast.showError(mesage)
    }
    
    fileprivate func log(_ mesage:String, params:[Any], withFuncName :Bool, level:FMLogLevelEnum, filename: String, line: Int, function: String) {
        
        
        
        var header = ""
        switch level {
        case .verbose:
            header = "[VERBOSE] "
        case .debug:
            header = "[DEBUG] "
        case .info:
            header = "[INFO] "
        case .error:
            header = "[ERROR] "
        }
        
        if HFLogLevel <= level.rawValue || Is_Build_For_App_Store {
            var str = "\(header)"
            if withFuncName {
                str +=  "\((filename as NSString).lastPathComponent):\(line) : "
            }
            str += "\(mesage)"
            
            if params.count > 0 {
                str += " [\n"
                for param in params  {
                    str += "\(param)\n"
                }
                str += "]\n------------------------"
            }
            if Is_Build_For_App_Store {
                CLSLogv("%@", getVaList([str]))
            } else {
                CLSNSLogv("%@", getVaList([str]))
            }
        }
    }
}
