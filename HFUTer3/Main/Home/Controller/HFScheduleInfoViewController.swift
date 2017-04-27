//
//  HFScheduleInfoViewController.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFScheduleInfoViewController: HFFormViewController {
    
    var models: [HFCourceViewModel] = []
    
    var segmentController: UISegmentedControl!
    
    var currentModel:  HFCourceViewModel? {
        if self.models.isEmpty {
            return nil
        } else {
            return models[segmentController.selectedSegmentIndex]
        }
    }
    
    var cacheData = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        var items: [String] = []
        for i in models.enumerated() {
            items.append("课程\(i.0 + 1)")
        }
        
        if !items.isEmpty {
            segmentController = UISegmentedControl(items: items)
            segmentController.selectedSegmentIndex = 0
            segmentController.addTarget(self, action: #selector(onSegmentChanged), for: .valueChanged)
            segmentController.tintColor = UIColor.white
            if let nav = nav {
                nav.addSubview(segmentController)
                segmentController.snp.makeConstraints {
                    $0.centerX.equalTo(nav)
                    $0.centerY.equalTo(nav).offset(10)
                }
            }
        }
        
        updateValue()
        
        nav?.showNavRightButton(with: "保存")
    }
    
    
    override func onNavRightButtonPressed() {
        
        var json: [String: Any?] = form.values()
        
        if
            let name = json["name"] as? String,
            let place = json["place"] as? String,
            let color = json["color"] as? String,
            name != "", place != "" {
            if let model = currentModel {
                Hud.showLoading("正在保存")
                model.update(name: name, color: color, place: place, completion: { (_) in
                   
                })
                
                delay(seconds: 1, completion: { 
                    runOnMainThread {
                        Hud.showMassage("保存成功")
                        NotificationCenter.default.post(name: HFNotification.scheduleUpdated.get(), object: nil)
                        self.pop()
                    }
                })
            } else {
                
            }
        } else {
            Hud.showError("请填写完整")
        }
}
    
    @objc fileprivate func onSegmentChanged() {
        updateValue()
    }
    
    func setupUI() {
        form +++ Section()
            
            <<< TextRow("name") {
                $0.title = "课程名称"
            }
            
            <<< TextRow("place") {
                $0.title = "上课地点"
            }
            
            <<< HFEurekaInfoRow("date") {
                $0.title = "上课时间"
                }.onCellSelection({ (cell, row) in
                    row.deselect()
                    let picker = HFScheduleTimePicker()
                    if let model = self.currentModel {
                        if !model.isUserAdded {
                            Hud.showError("只有用户添加课程能修改")
                            return
                        }
                        picker.setup(day: model.day, hour: model.start, duration: model.duration)
                    }
                    
                    picker.add(to: self.view)
                })
            
            <<< HFEurekaInfoRow("week") {
                $0.title = "教学周"
                }.onCellSelection({ (cell, row) in
                    row.deselect()
                    if let model = self.currentModel {
                        if !model.isUserAdded {
                            Hud.showError("只有用户添加课程能修改")
                            return
                        }
                    }
                    
                    let vc = HFScheduleWeekChoostViewController()
                    vc.selected = self.currentModel?.cources.first?.weeks ?? []
                    self.push(vc)
                })
            
            +++ Section()
            <<< HFEurekaInfoRow("color") {
                $0.title = "背景色"
                $0.isColor = true
                }.onCellSelection({ (cell, row) in
                    row.deselect()
                    let vc = HFMineChooseThemeViewController.instantiate()
                    vc.allowCustom = false
                    vc.selectedBlock = { [weak self] color in
                        self?.form.setValues(["color": color])
                        runOnMainThread {
                            self?.tableView?.reloadData()
                        }
                    }
                    self.push(vc)
                })
    }
    
    func updateValue() {
        if let model = currentModel {
            let week = model.cources.first?.weeks ?? []
            
            var values: [String: Any] = [
                "name"  : model.name,
                "place" : model.place,
                "week"  : week.map { $0.description }.joined(separator: ","),
                "color" : model.color
            ]
            
            if model.duration == 1 {
                values["date"] = "\(k.dayNames[model.day]) \(model.start) 节"
            } else {
                values["date"] = "\(k.dayNames[model.day]) \(model.start) - \(model.start + model.duration - 1) 节"
            }
            
            form.setValues(values)
            runOnMainThread {
                self.tableView?.reloadData()
            }
        }
    }
}
