//
//  HFMineSettingVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineSettingVC: HFBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    fileprivate func onAllowShowWeekenCourseSettingChanged(_ value:Bool) {
        DataEnv.settings.shouldShowWeekEndClass = value
        NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.SettingScheduleRelatedUpdate.rawValue), object: nil)
        
        if value {
            AnalyseManager.OpenWeekendSchudule.record()
        } else {
            AnalyseManager.CloseWeekendSchudule.record()
        }
    }

}

extension HFMineSettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "课表"
    }
}

extension HFMineSettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HFMineSettingSwitchCell", for: indexPath) as! HFMineSettingSwitchCell
        cell.titleLabel.text = "显示周末课程"
        cell.switchController.isOn = DataEnv.settings.shouldShowWeekEndClass
        cell.valueChangedBlock = { value in
            self.onAllowShowWeekenCourseSettingChanged(value)
        }
        return cell
    }
}
