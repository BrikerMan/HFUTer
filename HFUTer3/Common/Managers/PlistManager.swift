//
//  PlistManager.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/18.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation


class PlistManagerTool {
    static let shared = PlistManagerTool()
    
    /// 数据Plist
    let dataPlist:Plist
    /// 用户信息Plist
    let userDataPlist:Plist
    /// 设置Plist
    let settingsPlist:Plist
    
    // 初始化单例
    init() {
        dataPlist     = Plist(name: "DataPlist")
        userDataPlist = Plist(name: "UserPlist")
        settingsPlist = Plist(name: "SettingPlist")
    }
}



struct Plist {
    let name:String
    let destPath:String
    /**
     初始化
     
     - parameter name: Plist文件名
     
     - returns: Plist实体
     */
    init(name:String) {
        self.name = name + ".plist"        
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.eliyar.biz.hfuter")
        let pathString = path!.absoluteString.replacingOccurrences(of:"file:///private", with: "").replacingOccurrences(of:"file:///", with: "")
        destPath = (pathString as NSString).appendingPathComponent(name).characters.split{$0 == "."}.map(String.init).first!
        
//        let mypaths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        let mydocpath:String = mypaths.objectAtIndex(0) as! String
//        destPath = (mydocpath as NSString).stringByAppendingPathComponent(name)
    }
    
    /**
     读取Plist的值，作为字典返回
     
     - returns: 字典内容
     */
    func getValues() -> [String:Any]?{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath) {
            guard let dict = NSDictionary(contentsOfFile: destPath) else { return .none }
            return dict as? [String : Any]
        } else {
            return nil
        }
    }
    
    /**
     保存Plist的值
     
     - parameter dictionary: 保存的[Key:Value]字典。Key使用Macros里面的PlistKey，方便读取存储。
     */
    func saveValues(_ dictionary:[String:Any]) {
        var originalData = getValues() ?? [String:Any]()
        originalData.update(dictionary)
        let dic = originalData as NSDictionary
        dic.write(toFile: destPath, atomically: true)
    }
    
    /**
     清空Plist，用户退出时候用来初始化
     */
    func clearPlist() {
        let data = NSDictionary()
        data.write(toFile: destPath, atomically: false)
    }
}
