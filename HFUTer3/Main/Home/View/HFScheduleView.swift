//
//  FLScheduleView.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/26.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit

class HFScheduleView: HFView {
    
    var scrollView    = UIScrollView()
    var topView       = UIView()
    var leftView      = UIView()
    
    var containerView = UIView()
    
    var scheduleCells: [String: HFScheduleViewCell] = [:]
    
    override func initSetup() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        scrollView.addSubview(topView)
        scrollView.addSubview(leftView)
        scrollView.addSubview(containerView)
        
        topView.snp.makeConstraints {
            $0.left.top.right.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(30)
        }
        
        leftView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.bottom.equalTo(scrollView)
            $0.width.equalTo(30)
            $0.height.equalTo(scrollView.snp.height)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.equalTo(leftView.snp.right)
            $0.right.bottom.equalTo(scrollView)
        }
        
        topView.backgroundColor = UIColor.red
        leftView.backgroundColor = UIColor.blue
        containerView.backgroundColor = UIColor.gray
    }
    
    func setup(with schedules: [HFScheduleModel]) {
        
        let viewModels = group(schedules: schedules)
        drawScheduleView(viewModels: viewModels)
        
    }
    
    func drawScheduleView(viewModels: [HFCourceViewModel]) {
        let cellWidth  = (ScreenWidth - 30) / 5
        let cellHeight = (ScreenHeight - 64 - 49) / 11
        
        
        for model in viewModels {
            if let cell = scheduleCells["\(model.day)-\(model.start)"] {
                cell.add(model: model)
            } else {
                let cell = HFScheduleViewCell()
                cell.setup(model: model)
                containerView.addSubview(cell)
                
                cell.snp.makeConstraints {
                    $0.left.equalTo(containerView.snp.left).offset(cellWidth * CGFloat(model.day))
                    $0.top.equalTo(containerView.snp.top).offset(cellHeight * CGFloat(model.start))
                    $0.height.equalTo(cellHeight * model.duration.toCGFloat)
                    $0.width.equalTo(cellWidth)
                }
            }
        }
    }
    
    
    func group(schedules: [HFScheduleModel]) -> [HFCourceViewModel] {
        var dayList = Array<[HFScheduleModel]>(repeating: [], count: 7)
        for s in schedules {
            dayList[s.day].append(s)
        }
        
        var result: [HFCourceViewModel] = []
        
        for day in dayList {
            let sortedArray = day.sorted { (lts, rhs) -> Bool in
                if lts.name == rhs.name {
                    return lts.hour < rhs.hour
                }
                
                return lts.name > rhs.name
            }
            for (index, item) in sortedArray.enumerated() {
                if index > 0 {
                    if item.name == sortedArray[index - 1].name {
                        result.last?.cources.append(item)
                        print("同课程")
                        //        } else if item.hour == sortedArray[index - 1].hour {
                        //            print("不同课程重叠")
                    } else {
                        let model = HFCourceViewModel()
                        model.cources.append(item)
                        result.append(model)
                        print("不重叠")
                    }
                } else {
                    let model = HFCourceViewModel()
                    model.cources.append(item)
                    result.append(model)
                }
            }
        }
        return result
    }
}

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
    
    var description: String {
        return "\(cources) \(start) - \(start + duration - 1)"
    }
}
