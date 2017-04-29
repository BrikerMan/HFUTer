//
//  HFScheduleWeekChoostViewController.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFScheduleWeekChoostViewController: HFFormViewController {

    var selected: [Int] = []
    
    var completion: (([Int])->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        update()
        navTitle = "选择课程周"
        nav?.showNavRightButton(with: "确定")
    }
    
    override func onNavRightButtonPressed() {
        var result = [Int]()
        let value = form.values()
        for i in 1...24 {
            if let check = value["\(i)"] as? Bool, check {
                result.append(i)
            }
        }
        
        if result.isEmpty {
            Hud.showError("至少选择一周")
            return
        }
        self.completion?(result)
        self.pop()
    }


    
    func setup() {
        form +++ Section()
        for i in 1...24 {
            form.allSections.last!
                <<< CheckRow("\(i)") {
                $0.title = "\(i)"
            }
        }
    }
    
    
    func update() {
        var values: [String: Any] = [:]
        for i in 1...24 {
            values["\(i)"] = selected.contains(i)
        }
        form.setValues(values)
        tableView?.reloadData()
    }
}
