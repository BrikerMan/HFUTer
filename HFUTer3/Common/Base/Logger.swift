//
//  Logger.swift
//  FLive
//
//  Created by BrikerMan on 2017/2/13.
//  Copyright © 2017年 BrikerMan. All rights reserved.
//

import Foundation
import CocoaLumberjack

typealias Logger = BMLogger

class BMLogger {
    static func invoke() {
        DDTTYLogger.setup(release: .all, debug: .all)
        Logger.verbose("verbose Log")
        Logger.debug("debug Log")
        Logger.info("info Log")
        Logger.warning("warning Log")
        Logger.error("error Log")
    }
    
    /// log 等级描述
    /// - Verbose 最基础的消息，比如 api 响应
    /// - Debug   一些调试需要的信息，比如解析model等
    /// - Info    一些状态变化，比如登录，用户信息更新
    /// - Warning 警告，错误
    /// - Error   明确出错的地方
    
    
    // MARK: - Convenience logging methods
    /// Log something at the Verbose log level.
    ///
    /// - Parameters:
    ///     - closure:      A closure that returns the object to be logged.
    ///     - functionName: Normally omitted **Default:** *#function*.
    ///     - fileName:     Normally omitted **Default:** *#file*.
    ///     - lineNumber:   Normally omitted **Default:** *#line*.
    ///     - userInfo:     Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
    ///
    /// - Returns:  Nothing.
    ///
    static func verbose(_ message: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
        _DDLogMessage(message, level: level, flag: .verbose, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
    }

    static func debug(_ message: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
        _DDLogMessage(message, level: level, flag: .debug, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
    }
    
    static func info(_ message: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
        _DDLogMessage(message, level: level, flag: .info, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
    }
    
    static func warning(_ message: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
        _DDLogMessage(message, level: level, flag: .warning, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
    }
    
    static func error(_ message: @autoclosure () -> String, level: DDLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
        _DDLogMessage(message, level: level, flag: .error, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
    }
    
    static func lastLogPath() -> String? {
        for logger in DDLog.allLoggers where logger is DDFileLogger {
            if let logger = logger as? DDFileLogger {
                return logger.currentLogFileInfo.filePath
            }
        }
        return nil
    }
}

extension DDTTYLogger {
    static func setup(release: DDLogLevel, debug: DDLogLevel) {
        // Logging
        #if RELEASE
            defaultDebugLevel = release
        #else
            defaultDebugLevel = debug
        #endif
        
        // TTY Logging, Needs to install XcodeColors && KZLinkedConsole
        setenv("XcodeColors", "YES", 0)
        let logger = DDTTYLogger.sharedInstance
        logger?.setXcodeColors()
        logger?.logFormatter = CustomLogFormatter()
        DDLog.add(logger!)
        
        let fileLogger = DDFileLogger()
        fileLogger?.rollingFrequency = TimeInterval(60 * 60 * 24)
        fileLogger?.maximumFileSize = 1024 * 4
        
        DDLog.add(fileLogger!)
        
        
        
    }
    
    func setXcodeColors() {
        self.colorsEnabled = true
        self.setForegroundColor(UIColor(hexString: "#DB2C38")!, backgroundColor: nil, for: .error)
        self.setForegroundColor(UIColor(hexString: "#C67C48")!, backgroundColor: nil, for: .warning)
        self.setForegroundColor(UIColor(hexString: "#41B645")!, backgroundColor: nil, for: .info)
        self.setForegroundColor(UIColor(hexString: "#00A0BE")!, backgroundColor: nil, for: .debug)
    }
}

class CustomLogFormatter : NSObject, DDLogFormatter {
    private var loggerCount = 0
    private var dateFormatter : DateFormatter!
    
    override init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSSS"
    }
    
    
    func format(message logMessage: DDLogMessage) -> String? {
        var logLevel : String
        switch (logMessage.flag) {
        case DDLogFlag.error:
            logLevel = "[Error]  "
        case DDLogFlag.warning:
            logLevel = "[Warning]"
        case DDLogFlag.info:
            logLevel = "[Info]   "
        case DDLogFlag.debug:
            logLevel = "[Debug]  "
        case DDLogFlag.verbose:
            logLevel = "[Verbose]"
        default:
            logLevel = ""
        }
        
        let dateAndTime = self.dateFormatter.string(from: logMessage.timestamp)
        let fileName = logMessage.file.split("/").last ?? ""
        
        let formattedString = "\(dateAndTime) \(logLevel) | \(fileName):\(logMessage.line) | \(logMessage.message)"
        return formattedString
    }
    

    func didAdd(to logger: DDLogger) {
        self.loggerCount += 1
    }
    
    func willRemove(from logger: DDLogger) {
        self.loggerCount -= 1
    }
}
