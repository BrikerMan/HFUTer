//
//  DataManager.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import AlamofireDomain
import Pitaya

struct HFSettings {
    var shouldShowWeekEndClass:Bool
    
    init() {
        let data = PlistManager.settingsPlist.getValues()
        let settings = data?[HFSettingPlistKey.Settings.rawValue] as? JSON
        self.shouldShowWeekEndClass = settings?[HFSettingPlistKey.ShowWeekendSchedule.rawValue] as? Bool ?? false
    }
    
    func save() {
        let settings = [
            HFSettingPlistKey.ShowWeekendSchedule.rawValue : shouldShowWeekEndClass
        ]
        let data = [ HFSettingPlistKey.Settings.rawValue : settings]
        PlistManager.settingsPlist.saveValues(data as [String : AnyObject])
    }
}

/// 数据环境单例
class DataManager {
    static let shared = DataManager()
    
    /// 用户是否登陆
    var isLogin: Bool
    /// 全局用户模型，一旦有变化进行保存
    var user: HFUserModel? {
        didSet {
            user?.save()
        }
    }
    
    var token: String {
        didSet {
            PlistManager.userDataPlist.saveValues(["token":token as AnyObject])
        }
    }
    
    /// 是否获取Token，第一次发起请求时候先登陆，确保Token有效。
    var hasUpdateToken =  false
    
    /// 当前的课程周
    var currentWeek: Int {
        didSet {
            if currentWeek <= 1 {
                currentWeek = 1
            }
        }
    }
    
    var helpWebLinks = [String:String]()
    
    var allowDonate: Bool
    var allowDashang: Bool
    
    var settings: HFSettings {
        didSet {
            settings.save()
        }
    }
    
    init() {
        if let user = HFUserModel.read() {
            self.user = user
            self.isLogin = true
        } else {
            self.isLogin = false
        }
        token       = PlistManager.userDataPlist.getValues()?["token"] as? String ?? ""
        allowDonate = PlistManager.settingsPlist.getValues()?["allowDonate"] as? Bool ?? true
        allowDashang = PlistManager.settingsPlist.getValues()?["allowDashang"] as? Bool ?? false
        currentWeek = DataManager.calculateCurrentWeek()
        settings = HFSettings()
    }
    
    /**
     登出时调用，初始化全局数据环境
     */
    func handleLogout() {
        PlistManager.dataPlist.clearPlist()
        PlistManager.userDataPlist.clearPlist()
        isLogin = false
        hasUpdateToken =  false
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.UserLogout.rawValue), object: nil)
    }
    
    
    func updateUserInfo() {
        let request = HFUpdateUserInfoRequest()
        request.callback = self
        request.loadData()
    }
    
    
    // 更新 Host 和通知
    func updataHostInfo() {
        APIBaseURL = PlistManager.settingsPlist.getValues()?["BaseApiManger"] as? String ?? APIBaseURL
        AlamofireDomain.request(ServerInfoFile, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                if let resultDic = response.result.value as? [String:AnyObject], let host = resultDic["host"] as? String {
                    APIBaseURL =  "http://" + host
                    PlistManager.settingsPlist.saveValues(["BaseApiManger":APIBaseURL as AnyObject])
                }
        }
        
        
        Pitaya.build(HTTPMethod: .GET, url: SettingInfo)
            .responseJSON { (json, response) in
                
                self.allowDonate  = json["allowDonate"].boolValue
                self.allowDashang  = json["allowDashang"].boolValue
                
                PlistManager.settingsPlist.saveValues(["allowDonate"  : self.allowDonate])
                PlistManager.settingsPlist.saveValues(["allowDashang" : self.allowDashang])
                if let link = json["helpWebLinks"].data as? [String:String] {
                    self.helpWebLinks = link
                }
                
                if let id = json["notif"]["id"].int, let info = json["notif"]["info"].string {
                    let ignored = PlistManager.settingsPlist.getValues()?["ignored"] as? [Int] ?? []
                    if !ignored.contains(id) {
                        delay(seconds: 6, completion: {
                            NotificationCenter.default.post(name: HFNotification.receiveNewAppNotif.get(),
                                                            object: nil,
                                                            userInfo: ["info" : info,
                                                                       "id"   : id])
                        })
                        
                    }
                }
        }
        
        
        /*
        
         */
    }
    
    func saveToken(_ headers: [AnyHashable: Any]) {
        if let tokenString = headers["Set-Cookie"] as? String,
            let access = tokenString.matchesForRegexInText("access_token=\\w*;", text: tokenString).first,
            let refresh = tokenString.matchesForRegexInText("refresh_token=\\w*;", text: tokenString).first {
            DataEnv.token = access + refresh
            log.debugLog("刷新Token成功", params: [access + refresh])
            DataEnv.hasUpdateToken = true
        }
        
    }
    
    /**
     计算当前是第几周
     这次两边开学时间一致，没做区分计算
     */
    class func calculateCurrentWeek() -> Int {
        let from = TimeInterval(HFSemesterStartTime)
        let now = (Date().timeIntervalSince1970)
        var week = Int((now - from)/(7 * 24 * 3600)) + 1
        if week < 0 {
            week = 0
        }
        return week
    }
}

extension DataManager: HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        if let user = HFUserLoginViewModel().prepareModel(fromDictionary: manager.resultDic) {
            user.password = DataEnv.user!.password
            DataEnv.user = user
            DataEnv.user?.save()
            NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.UserInfoUpdate.rawValue), object: nil)
        }
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        
    }
}
