//
//  AnalyseManager.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/7/13.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Crashlytics

struct ContentViewStruct {
    var name: String
    var type: String
    
    init(name:String, type:String) {
        self.name = name
        self.type = type
    }
    
    func record() {
        Answers.logContentView(withName: name, contentType: type, contentId: name, customAttributes: nil)
    }
}


class AnalyseManager {
    /* 查询相关功能 */
    static let CheckGrades = ContentViewStruct(name: "查看成绩", type: "成绩")
    static let CheckGPA    = ContentViewStruct(name: "查看绩点", type: "成绩")
    static let SelfCheckGPS = ContentViewStruct(name: "自定义计算绩点", type: "成绩")
    
    static let QueryAcademicClass = ContentViewStruct(name: "查看教学班", type: "教学班")
    static let QueryAcademicClassDetail = ContentViewStruct(name: "查看教学班详情", type: "教学班")
    
    static let QueryCharges = ContentViewStruct(name: "查看收费", type: "收费")
    
    static let QueryPlan = ContentViewStruct(name: "查看计划", type: "计划")
    static let QueryPlanList = ContentViewStruct(name: "查看计划列表", type: "计划")
    static let QueryPlanDetail = ContentViewStruct(name: "查看计划详情", type: "计划")
    
    static let QueryCalender = ContentViewStruct(name: "查看校历", type: "校历")
    static let QueryEmptyClassroom = ContentViewStruct(name: "查看空教室", type: "空教室")
    static let QueryBook = ContentViewStruct(name: "查看图书借阅", type: "图书借阅")
    
    /* 社区相关功能 */
    static let UpdateLostThings = ContentViewStruct(name: "查看失物招领", type: "失物招领")
    static let PostLostThing = ContentViewStruct(name: "发布失物招领", type: "失物招领")
    static let ConnectLoster = ContentViewStruct(name: "联系失物招领", type: "失物招领")
    
    static let UpdateLoveWall = ContentViewStruct(name: "查看表白墙", type: "表白墙")
    static let PostLoveWall = ContentViewStruct(name: "发布表白", type: "表白墙")
    static let CommentLoveWall = ContentViewStruct(name: "发布表白墙评论", type: "表白墙")
    
    static let DeletePostLost = ContentViewStruct(name: "删除个人失物招领", type: "失物招领")
    static let DeletePostLove = ContentViewStruct(name: "删除个人表白墙", type: "表白墙")
    
    /* 课表相关功能 */
    static let OpenSchudule = ContentViewStruct(name: "查看课表", type: "课表")
    static let ChangeWeeks  = ContentViewStruct(name: "查看其它周课表", type: "课表")
    static let OpenWeekendSchudule = ContentViewStruct(name: "打开周末课表", type: "课表")
    static let CloseWeekendSchudule = ContentViewStruct(name: "关闭周末课表", type: "课表")
    
    /* 我的相关功能 */
    static let BindJWXT = ContentViewStruct(name: "绑定教务系统", type: "个人信息")
    static let BindXXMH = ContentViewStruct(name: "绑定信息门户", type: "个人信息")
    static let BindMail = ContentViewStruct(name: "绑定邮箱", type: "个人信息")
    static let ChangePassword = ContentViewStruct(name: "修改密码", type: "个人信息")
    static let ChangePhoto = ContentViewStruct(name: "修改头像", type: "个人信息")
    
    static let SeeSelfPost = ContentViewStruct(name: "查看个人发布", type: "个人信息")
    static let SeeMessages = ContentViewStruct(name: "查看消息", type: "个人信息")
    static let Donate = ContentViewStruct(name: "打赏作者", type: "个人信息")
    static let SeeAbout = ContentViewStruct(name: "查看关于", type: "个人信息")
    
    static let Logout = ContentViewStruct(name:"退出登录",type: "退出登录")
    
    
}
