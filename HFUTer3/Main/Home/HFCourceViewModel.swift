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
    
    func cleanUP() {
        DBManager.delete(id: self.cources.map({ $0.id}), from: .schedule)
    }
    
    static func create(model: HFScheduleModel) {
        for i in 0..<model.duration {
            let cource = HFScheduleModel()
            
            cource.name        = model.name
            cource.place       = model.place
            cource.colorName   = model.colorName
            
            cource.weeks       = model.weeks
            cource.isUserAdded = true
            cource.hour        = model.hour + i
            DBManager.insert(item: cource, to: .schedule)
        }
    }
    
    func update(name: String, color: String, place: String, weeks: [Int]) {
        let models = DBManager.read(from: .schedule, type: HFScheduleModel.self, filter: "name = '\(self.name)'")
        for cource in models {
            cource.name      = name
            cource.place     = place
            cource.colorName = color
            cource.weeks     = weeks
            DBManager.insert(item: cource, to: .schedule)
        }
    }
}
