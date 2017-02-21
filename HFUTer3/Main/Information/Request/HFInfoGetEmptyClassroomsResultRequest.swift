//
//  HFInfoGetEmptyClassroomsResultRequest.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGetEmptyClassroomsResultRequest: HFBaseAPIManager {
    
    var teachingBuilding = "" //教学楼
    var floor = "" //层
    var teachingWeek = ""//教学周
    var week = ""//周几
    var section = ""//第几节课
    
    func startQuery(withteachingBuilding teachingBuilding:String,floor:String,teachingWeek:String,week:String,section:String){
        self.teachingBuilding = teachingBuilding
        self.floor = floor
        self.teachingWeek = teachingWeek
        self.week = week
        self.section = section
        self.loadData()
    }
    
    override func reqeustSubURL() -> String? {
        return "/api/user/query/emptyClassRoomResult"
    }
    
    override func requestParams() -> [String : Any]? {
        return [
            "teachingBuilding":teachingBuilding,
            "floor":floor,
            "teachingWeek":teachingWeek,
            "week":week,
            "section":section
        ]
    }
    
    static func handleData(_ dic:[String:AnyObject]) -> String? {
        if let result = dic[JSONDataKey] {
            return result as? String
        }
        return nil
    }
    
}
