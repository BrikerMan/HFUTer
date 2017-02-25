//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by BrikerMan on 16/8/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todayCourses    = [HFCourseModel]()
    var tomorrowCourses = [HFCourseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        let newData = DataManager.shared.getTodayCorse()
        let tomorrowNew = DataManager.shared.getTomoorCourse()
        if todayCourses == newData && tomorrowCourses == tomorrowNew {
            completionHandler(NCUpdateResult.noData)
            return
        }
        todayCourses    = newData
        tomorrowCourses = tomorrowNew
        tableView.reloadData()
        self.preferredContentSize = self.tableView.contentSize
        completionHandler(NCUpdateResult.newData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            self.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 110)
        case .expanded:
            self.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 110)
        }
    }
    
    func updateData() {
        todayCourses    = DataManager.shared.getTodayCorse()
        tomorrowCourses = DataManager.shared.getTomoorCourse()
        tableView.reloadData()
        self.preferredContentSize = self.tableView.contentSize

    }
    
    func courseForIndexPath(_ index: IndexPath) -> [HFCourseModel]{
        if index.section == 0 {
            return todayCourses
        } else {
            return tomorrowCourses
        }
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}


extension TodayViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let models = section == 0 ? todayCourses : tomorrowCourses
        if models.isEmpty && !(todayCourses.isEmpty && tomorrowCourses.isEmpty){
            return 0
        } else {
            return models.count + 1
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourceDayHeaderCell") as! CourceDayHeaderCell
            cell.titleLabel.text = DataManager.shared.getHeaderString(indexPath.section == 0)
            return cell
        } else if courseForIndexPath(indexPath).isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoCourceTableViewCell")!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell")! as! CourseTableViewCell
            cell.blind(courseForIndexPath(indexPath)[indexPath.row - 1])
            return cell
        }
    }
}


extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        extensionContext?.open(URL(string: "hfuter://")!, completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        } else {
            return 60
        }
    }
}
