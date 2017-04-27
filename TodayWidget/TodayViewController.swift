//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by BrikerMan on 16/8/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import NotificationCenter

struct CourseListType {
    var isToday: Bool
    var cources: [HFCourceViewModel]
    
}

extension CourseListType: Equatable {
    static func == (lhs: CourseListType, rhs: CourseListType) -> Bool {
        return lhs.cources == rhs.cources && lhs.isToday == rhs.isToday
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tableView: UITableView!

    fileprivate var cources: [CourseListType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        updateData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        let new = fetchNewData()
        if new == cources {
            completionHandler(NCUpdateResult.noData)
            return
        }
        cources = new
        reloadUI()
        completionHandler(NCUpdateResult.newData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        switch activeDisplayMode {
        case .compact:
            let height = 30
//            if !cources.isEmpty {
//                height = cources[0].cources.count * 60 + 30
//            }
            UIView.animate(withDuration: 0.25, animations: {
                self.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(height))
            })
            
        case .expanded:
            var height: CGFloat
            if !cources.isEmpty {
                height = 0
                for c in cources {
                   height += CGFloat(c.cources.count * 60 + 30)
                }
            } else {
                height = 30
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: height)
            })
        }
    }
    
    func updateData() {
        cources = fetchNewData()
        reloadUI()
    }
    
    fileprivate func reloadUI() {
        tableView.reloadData()
        if #available(iOSApplicationExtension 10.0, *) {
            if !cources.isEmpty {
                extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            } else {
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
            }
        } else {
            preferredContentSize = tableView.contentSize
        }
    }
    
    fileprivate func fetchNewData() -> [CourseListType] {
        var new: [CourseListType] = []
        let todayCourses    = DataManager.shared.getTodayCorse()
        let tomorrowCourses = DataManager.shared.getTomoorCourse()
        if !todayCourses.isEmpty {
            new.append(CourseListType(isToday: true, cources: todayCourses))
        }
        if !tomorrowCourses.isEmpty {
            new.append(CourseListType(isToday: false,cources: tomorrowCourses))
        }
        return new
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}


extension TodayViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if cources.isEmpty {
            return 1
        } else {
            return cources.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cources.isEmpty {
            return 1
        } else {
            return cources[section].cources.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cources.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoCourceTableViewCell")!
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CourceDayHeaderCell") as! CourceDayHeaderCell
                cell.titleLabel.text = DataManager.shared.getHeaderString(cources[indexPath.section].isToday)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell")! as! CourseTableViewCell
                let model = cources[indexPath.section].cources[indexPath.row - 1]
                cell.blind(model)
                return cell
            }
        }
    }
}


extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        extensionContext?.open(URL(string: "hfuter://")!, completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        } else {
            return 60
        }
    }
}
