//
//  HFCourceViewModel.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFCourceViewModel: CustomStringConvertible {
    var cources: [HFScheduleModel] = []
    
    var name: String {
        return cources.first?.name ?? ""
    }
    
    var place: String {
        return cources.first?.place ?? ""
    }
    
    var day: Int {
        return cources.first?.day ?? 0
    }
    
    var start: Int {
        return cources.first?.hour ?? 0
    }
    
    var duration: Int {
        return cources.count
    }
    
    var color: String {
        return cources.first?.colorName ?? ""
    }
    
    var isUserAdded: Bool {
        return cources.first?.isUserAdded ?? false
    }
    
    var description: String {
        return "\(cources) \(start) - \(start + duration - 1)"
    }
    
    func create(name: String, place: String, day: Int, start: Int, duration: Int, week: [Int], color: String, completion: @escaping BoolBlock) {
        DBManager.delete(id: self.cources.map({ $0.id}), from: .schedule)
        
        for i in 0..<duration {
            let cource = HFScheduleModel()
            
            cource.name        = name
            cource.place       = place
            cource.colorName   = color
            
            cource.weeks       = week
            cource.isUserAdded = true
            cource.hour        = start + i
            DBManager.insert(item: cource, to: .schedule)
        }
    }
    
    func update(name: String, color: String, place: String, completion: @escaping BoolBlock) {
        
        let models = DBManager.read(from: .schedule, type: HFScheduleModel.self, filter: "name = '\(self.name)'")
        for cource in models {
            cource.name        = name
            cource.place       = place
            cource.colorName   = color
            DBManager.insert(item: cource, to: .schedule, completion: completion)
        }
    }
}
