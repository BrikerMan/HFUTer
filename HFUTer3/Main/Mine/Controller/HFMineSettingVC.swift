//
//  HFMineSettingVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFMineSettingVC: HFFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("课表设置")
            <<< SwitchRow() {
                $0.title = "显示周末课程"
                $0.value =  DataEnv.settings.weekendSchedule.value
                }.onChange({ (row) in
                    DataEnv.settings.weekendSchedule.value = row.value!
                    DataEnv.settings.save()
                    if DataEnv.settings.weekendSchedule.value {
                        AnalyseManager.OpenWeekendSchudule.record()
                    } else {
                        AnalyseManager.CloseWeekendSchudule.record()
                    }
                })
            
            <<< SwitchRow() {
                $0.title = "课表圆角风格"
                $0.value =  DataEnv.settings.scheduleRoundStyle.value
                }.onChange({ (row) in
                    DataEnv.settings.scheduleRoundStyle.value = row.value!
                    DataEnv.settings.save()
                })
            
            +++ Section()
            <<< ButtonRow("上传 log") {
                $0.title = $0.tag
                $0.presentationMode = .show(controllerProvider: ControllerProvider.callback {
                    return HFMineRepostViewController()
                    }, onDismiss: { vc in
                        _ = vc.navigationController?.popViewController(animated: true)
                })
        }
    }
}
