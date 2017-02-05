//
//  HFScheduleViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/2/4.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFScheduleViewModel {
    
    
    func loadData(week: Int, completion: ((_ models: [CourseDayModel]) -> Void)) {
        if let result = HFCourseModel.readCourses(forWeek: week) {
            completion(result)
        } else {
            HFEducationRequest.getSchedule(progressBlock: { (progress, finished, success, json) in
                Hud.showPregress(progress)
                if finished {
                    self.save(data: json)
                }
            })
        }
    }
    
    func save(data: JSONItem) {
        if let array = data.RAWValue.jsonToArray() {
            PlistManager.dataPlist.saveValues([PlistKey.ScheduleList.rawValue: array])
        }
    }
}
