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
    
    var newModel = HFScheduleModel()
    
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
        
        if let model = currentModel {
            newModel.name  = model.name
            newModel.place = model.place
            newModel.weeks = model.cources.first?.weeks ?? []
            newModel.colorName = model.color
            newModel.duration = model.duration
            newModel.hour = model.start
        } else {
            navTitle = "创建新课程"
        }
        updateValue()
        nav?.showNavRightButton(with: "保存")
    }
    
    
    override func onNavRightButtonPressed() {
        if newModel.name != "", newModel.place != "", newModel.weeks != [], newModel.duration != 0  {
            if let model = currentModel {
                Hud.showLoading("正在保存")
                if model.isUserAdded {
                    model.cleanUP()
                    HFCourceViewModel.create(model: newModel)
                } else {
                    model.update(name: newModel.name, color: newModel.colorName, place: newModel.place, weeks: newModel.weeks)
                }
                
            } else {
                HFCourceViewModel.create(model: newModel)
            }
            delay(seconds: 1, completion: {
                runOnMainThread {
                    Hud.showMassage("保存成功")
                    NotificationCenter.default.post(name: HFNotification.scheduleUpdated.get(), object: nil)
                    self.pop()
                }
            })
        } else {
            Hud.showError("请填写完整")
        }
    }
    
    @objc fileprivate func onSegmentChanged() {
        form.setValues(["name": "", "place": ""])
        if let model = currentModel {
            newModel.name  = model.name
            newModel.place = model.place
            newModel.weeks = model.cources.first?.weeks ?? []
            newModel.colorName = model.color
            newModel.duration = model.duration
            newModel.hour = model.start
        }
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
                    picker.finishedBlock = { [weak self] (day, hour, duration) in
                        self?.newModel.day      = day
                        self?.newModel.hour     = hour
                        self?.newModel.duration = duration
                        self?.updateValue()
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
                    vc.selected =  self.newModel.weeks
                    vc.completion = { [weak self]  week in
                        self?.newModel.weeks = week
                        self?.updateValue()
                    }
                    self.push(vc)
                })
            
            +++ Section()
            <<< HFEurekaInfoRow("color") {
                $0.title = "背景色"
                $0.value = "Sunset Orange"
                $0.isColor = true
                }.onCellSelection({ (cell, row) in
                    row.deselect()
                    let vc = HFMineChooseThemeViewController.instantiate()
                    vc.allowCustom = false
                    vc.selectedColor = row.value ?? "Sunset Orange"
                    vc.selectedBlock = { [weak self] color in
                        self?.newModel.colorName = color
                        self?.updateValue()
                    }
                    self.push(vc)
                })
        
        if !models.isEmpty {
            form +++ Section()
                <<< ButtonRow("delete"){
                    $0.title = "删除"
                    }.onCellSelection({ (_, _) in
                        self.currentModel?.cleanUP()
                        Hud.showLoading()
                        delay(seconds: 1, completion: {
                            Hud.dismiss()
                            NotificationCenter.default.post(name: HFNotification.scheduleUpdated.get(), object: nil)
                            self.pop()
                        })
                    })
        }
        
    }
    
    func updateValue() {
        let json = form.values()
        
        if let name = json["name"] as? String, name != "" {
            newModel.name = name
        }
        
        if let place = json["place"] as? String, place != "" {
            newModel.place = place
        }
        
        var values: [String: Any] = [
            "name"  : newModel.name,
            "place" : newModel.place,
            "week"  : newModel.weeks.map { $0.description }.joined(separator: ","),
            "color" : newModel.colorName
        ]
        
        if newModel.duration != 0 {
            if newModel.duration == 1 {
                values["date"] = "\(k.dayNames[newModel.day]) \(newModel.hour + 1) 节"
            } else {
                values["date"] = "\(k.dayNames[newModel.day]) \(newModel.hour + 1) - \(newModel.hour + newModel.duration) 节"
            }
        }
        form.setValues(values)
        runOnMainThread {
            self.tableView?.reloadData()
        }    }
}
