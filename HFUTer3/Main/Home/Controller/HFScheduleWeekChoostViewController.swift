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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        update()
        navTitle = "选择课程周"
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
        tableView?.reloadData()
    }
}
