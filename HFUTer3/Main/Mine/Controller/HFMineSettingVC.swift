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
        
        form +++ Section()
            <<< SwitchRow() {
                $0.title = "显示周末课程"
                $0.value =  DataEnv.settings.shouldShowWeekEndClass
                }.onChange({ (row) in
                    DataEnv.settings.shouldShowWeekEndClass = row.value!
                    NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.SettingScheduleRelatedUpdate.rawValue), object: nil)
                    if DataEnv.settings.shouldShowWeekEndClass {
                        AnalyseManager.OpenWeekendSchudule.record()
                    } else {
                        AnalyseManager.CloseWeekendSchudule.record()
                    }
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
