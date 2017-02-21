//
//  HFScheduleViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/2/4.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFScheduleViewModel {
    
    func loadData(week: Int, completion: @escaping ((_ models: [CourseDayModel]) -> Void)) {
        HFEducationRequest.getSchedule(progress: { (progress) in
            HFToast.showError(progress)
            
        }, success: { (result) in
//            print(result)
        }, failed: { (error) in
            HFToast.showError(error)
            
        })

        
        if let result = HFCourseModel.readCourses(forWeek: week) {
            completion(result)
        } else {
            HFEducationRequest.getSchedule(progress: { (progress) in
                HFToast.showError(progress)
            
            }, success: { (result) in
                print(result)
                self.save(data: result["data"])
                if let result = HFCourseModel.readCourses(forWeek: week) {
                    completion(result)
                }
            }, failed: { (error) in
                HFToast.showError(error)
            })
            
        }
    }
    
    func save(data: JSONItem) {
        if let array = data.RAWValue.jsonToArray() {
            PlistManager.dataPlist.saveValues([PlistKey.ScheduleList.rawValue: array])
        }
    }
}
