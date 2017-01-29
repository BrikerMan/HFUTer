//
//  Macros.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/15.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit

////////////////////////////////////////////////////////////////////////
//Base Data

let HFLogLevel      = 0

let ServerInfoFile  = "https://coding.net/u/Haidy/p/HfuterSettings/git/raw/master/host"
var APIBaseURL      = "http://wehfut.duapp.com"
let SettingInfo     = "https://coding.net/u/eliyar917/p/HFUTer-Settings/git/raw/master/setting"

let HFSemesterStartTime = 1472407200
let XCSemesterStartTime = 1472407200

let JSPatchAppKey   = "b8f87fcd146b9bc8"
let JPushAppKey     = "c7031180612e5564f89cca6e"

let UmengKey        = "5580d53a67e58e3b3b0004b0"

let LeanCLoudAppID: String = {
    return Is_Build_For_App_Store ? "jkqbCp9Or4g2CJLkgbOFjAle-gzGzoHsz" : "hca5zxrj5geqsdsii23jfo5lcqtueigop6f2vlabcv1bpgfo"
}()

let LeanCLoudAppKey: String = {
    return Is_Build_For_App_Store ? "FJekvLQh3PBLkJFnLN8CmYGQ" : "tamnh8ezqfmtd9ssofgcl6sf22xccmg2xayv4x2av4hx1oqw"
}()

let AppVersion: String = {
    var key = "CFBundleShortVersionString"
    let infoPlist = Bundle.main.infoDictionary!
    let version = infoPlist[key] as! String
    return version
}()

////////////////////////////////////////////////////////////////////////
//DataKey

let JSONDataKey             = "data"

/**
 Plist数据保存时候用的Keys
 
 - UserData:     用户数据
 - ScheduleList: 课表
 - GradesList:   成绩
 - CalculateGradesList: 计算绩点的自定义设置
 */
enum PlistKey:String {
    case UserData       = "UserData"
    case ScheduleList   = "ScheduleList"
    case GradesList     = "GradesList"
    case CalculateGradesList = "CalculateGradesList"
}

enum HFSettingPlistKey: String {
    case Settings               = "SettingsList"
    case ShowWeekendSchedule    = "ShowWeekendSchedule"
}

////////////////////////////////////////////////////////////////////////
//UI

let ScreenWidth     = UIScreen.main.bounds.size.width
let ScreenHeight    = UIScreen.main.bounds.size.height
let ScreenScale     = UIScreen.main.scale

let SeperatorHeight = 1 / UIScreen.main.scale

////////////////////////////////////////////////////////////////////////
//Managers

let HFTheme         = ColorManager.shared
let hud             = HFHudView.shared
let DataEnv         = DataManager.shared
let log             = FMLogTool.shared
let PlistManager    = PlistManagerTool.shared

typealias HFRequestParam = [String: Any]
typealias JSON = [String: Any]

////////////////////////////////////////////////////////////////////////
//Notification


enum HFNotification: String {
    case UserLogin          = "HFUserLoginNotification"
    case UserLogout         = "HFUserLogoutNotification"
    case UserInfoUpdate     = "HFUserInfoUpdateNotification"
    
    case LoveWallModelUpdate = "LoveWallModelUpdateNotification"
    
    case SettingScheduleRelatedUpdate = "HFSettingScheduleRelatedSetttingUpdateNotification"
    
    case ReceiveRemoteNotif = "ReceiveRemoteNotifNotification"
    case RemoveBundge       = "RemoveBundgeNotification"
    
    case receiveNewAppNotif = "receiveNewAppNotifNotification"
    
    
    func get() -> NSNotification.Name{
         return NSNotification.Name(self.rawValue)
    }
}

let HFUserLoginNotification = "HFUserLoginNotification"
let HFUserLogoutNotification = "HFUserLogoutNotification"


////////////////////////////////////////////////////////////////////////
//Segues

let PushRegisterSetEmailSegue               = "PushRegisterSetEmailSegue"
let PushRegisterSetNickNameAndAvatarSegue   = "PushRegisterSetNickNameAndAvatarSegue"


enum HFInfoSegue:String {
    // 教学班
    case PushClassListVC        = "HFInfoSeguePushAcadamicClassListVC"
    case PushClassDetailVC      = "HFInfoSeguePushAcadamicClassDetailVC"
    
    // 成绩
    case PushGradesVC           = "HFInfoSeguePushGradesListVC"
    case PushGradesStaticVC     = "HFInfoSeguePushGradesStaticVC"
    case PushGradesCalculatorVC = "HFInfoSeguePushGradesCalculatorVC"
    
    // 收费
    case PushChargesVC          = "HFInfoSeguePushChargesVC"
    
    // 计划
    case PushPlansVC            = "HFInfoSeguePushPlansVC"
    
    //空教室
    case PushEmptyClassroomVC   = "HFInfoSeguePushEmptyClassroomVC"
    
    //图书借阅
    case PushBookListVC         = "HFInfoSeguePushBookListVC"
    
    // 排名查询
    case PushRankingVC          = "HFInfoSeguePushRankingVC"
}

enum HFMineSegue:String {
    // 个人信息
    case PushInfoVC             = "HFMineSeguePushInfoVC"
    
    // 个人信息设置
    case PushSettingVC          = "HFMineSeguePushSettingVC"
    
    // 我的发布
    case PushMyPublishVC        = "HFMineSeguePushMyPublishVC"
    
    // 我的消息
    case PushMyMessageVC        = "HFMineSeguePushMyMessageVC"
}
