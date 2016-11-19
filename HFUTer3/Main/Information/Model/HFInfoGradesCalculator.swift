//
//  Calculator.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/25.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFInfoGradesCalculator {


    
    func calculateGPA(_ terms:[HFTermModel]) -> [HFInfoGradesGPAModel] {
        var GPAList:[HFInfoGradesGPAModel] = []
        
        if terms.count == 0 {
            return GPAList
        }
        
        var cridets:Float       = 0
        var gpas:Float          = 0
        var selectCridets:Float = 0
        var avarages:Float      = 0
        
        for term in terms {
            let termGPA =  calculateGPAForTerm(term)
            GPAList.append(termGPA)
            
            cridets         += termGPA.cridets
            gpas            += termGPA.gpa * termGPA.cridets
            selectCridets   += termGPA.selectionCridets
            avarages        += termGPA.avarage * termGPA.cridets
        }
        
        
        let model = HFInfoGradesGPAModel()
        model.term    = "总共"
        model.cridets = cridets
        model.selectionCridets = selectCridets
        model.gpa = divider(gpas,cridets)
        model.avarage = divider(avarages,cridets)
        
        var newGPAList:[HFInfoGradesGPAModel] = []
        newGPAList.append(model)
        newGPAList.append(contentsOf: GPAList)
        
        return newGPAList
        
    }
    
    func calculateGPAForTerm(_ term: HFTermModel) -> HFInfoGradesGPAModel {
        var cridets:Float       = 0
        var gpas:Float          = 0
        var selectCridets:Float = 0
        var avarages:Float      = 0
        
        for score in term.scoreList {
            let cridet = Float(score.credit) ?? 0.0
            if let gpa = Float(score.gpa) {
                gpas += gpa * cridet
                avarages += Float(calculateAverageForScore(score.score)) * cridet
                cridets += cridet
            } else {
                selectCridets += cridet
            }
        }
        
        
        let model = HFInfoGradesGPAModel()
        model.term    = term.term
        model.cridets = cridets
        model.selectionCridets = selectCridets
        model.gpa = divider(gpas,cridets)
        model.avarage = divider(avarages,cridets)
        
        return model
    }
    
    
    func divider(_ left: Float, _ right: Float ) -> Float {
        if right == 0 {
            return  0
        } else {
            return left/right
        }
    }
    
    func calculateAverageForScore(_ score:String) -> Int{
        switch score{
        case "优":
            return 95
        case "良":
            return 85
        case "中":
            return 75
        case "及格":
            return 60
        case "不及格":
            return 50
        case "未考":
            return 0
        case "免修":
            return 95
        default:
            if let mark = Int(score) {
                return mark
            } else {
                return 0
            }
        }
    }
    

    func calculateGPAForScore(_ score:String) -> Float{
        switch score{
        case "优":
            return 3.9
        case "良":
            return 3.0
        case "中":
            return 2.0
        case "及格":
            return 1.0
        case "旷考","不及格","未考":
            return 0.0
        case "免修":
            return 0
        default:
            if let mark = Int(score) {
                if mark <= 100 && mark >= 95{
                    return 4.3
                } else if mark >= 90 {
                    return 4.0
                } else if mark >= 85 {
                    return 3.7
                } else if mark >= 82 {
                    return 3.3
                } else if mark >= 78 {
                    return 3.0
                } else if mark >= 75 {
                    return 2.7
                } else if mark >= 72 {
                    return 2.3
                } else if mark >= 68 {
                    return 2.0
                } else if mark >= 66 {
                    return 1.7
                } else if mark >= 64 {
                    return 1.3
                } else if mark >= 60 {
                    return 1
                } else {
                    return 0
                }
            } else {
                return 0.0
            }
        }
    }
}
