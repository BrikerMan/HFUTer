//
//  HFHomeSchudulesView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/19.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol HFHomeSchudulesViewDelegate :class{
    func scheduleViewDidStartRefresh()
}

class HFHomeSchudulesView: HFXibView {
    
    weak var delegate: HFHomeSchudulesViewDelegate?
    
    var dayCount: CGFloat = 5
    var courseDays:[CourseDayModel] = []
    
    fileprivate var originalDayNames = ["","周一","周二","周三","周四","周五","周六","周日"]
    fileprivate let timeNamesList = ["","1\n-\n2","3\n-\n4","5\n-\n6","7\n-\n8","9\n-\n11"]
    fileprivate var dayNamesList = ["","周一","周二","周三","周四","周五","周六","周日"]
    
    @IBOutlet weak var collectionView: HFPullCollectionView!
    
    
    func reloadData() {
        self.updateDaysSetting()
    }
    
    
    func setupWithCourses(_ courses:[CourseDayModel]) {
        self.courseDays = courses
        self.collectionView.endRefresh()
        self.collectionView.reloadData()
    }
    
    func setupWithWeek(_ week:Int) {
        if DataEnv.isLogin {
            let weekDayString = DataHelper.getDaysListForWeek(week)
            
            for day in 0..<weekDayString.count {
                if week == 0 {
                    dayNamesList[day] = originalDayNames[day]
                } else {
                    dayNamesList[day] = originalDayNames[day] + "\n" + weekDayString[day]
                }
            }
        }
    }
    
    fileprivate func updateDaysSetting() {
        if DataEnv.settings.shouldShowWeekEndClass {
            self.dayCount = 7
        } else {
            self.dayCount = 5
        }
        
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        
    }
    
    override func initFromXib() {
        super.initFromXib()
        
        collectionView.pullDelegate = self
        collectionView.backgroundColor = HFTheme.BlackAreaColor
        
        let bodyNib = UINib(nibName: "HFHomeScheduleBodyCell", bundle: nil)
        collectionView.register(bodyNib, forCellWithReuseIdentifier: "bodyCell")
        
        let headerNib = UINib(nibName: "HFHomeScheduleHeaderCell", bundle: nil)
        collectionView.register(headerNib, forCellWithReuseIdentifier: "headerCell")
        
        let titleNib = UINib(nibName: "HFHomeScheduleTitleCell", bundle: nil)
        collectionView.register(titleNib, forCellWithReuseIdentifier: "titleCell")
        
        updateDaysSetting()
        
    }
    
    
    /**
     根据indexPath计算是否是大课小课。isDouble为是则为两个小课，否则为大课。
     */
    func prepareCourseForIndex(_ indexPath:IndexPath) -> (isDouble: Bool,models:[CourseHourModel])?{
        var isDouble = false
        var hours: [CourseHourModel] = []
        if courseDays.count >= 7 {
            switch indexPath.section {
            case 1,2,3,4,5:
                let left = courseDays[indexPath.row-1].hours[(indexPath.section-1)*2]
                let right = courseDays[indexPath.row-1].hours[(indexPath.section-1)*2+1]
                if left != right {
                    isDouble = true
                    hours = [left,right]
                } else {
                    hours = [left]
                }
            default:
                return nil
            }
            return (isDouble,hours)
        }
        return nil
    }
}

extension HFHomeSchudulesView: HFPullCollectionViewPullDelegate {
    func pullCollectionViewStartRefreshing(_ collectionView: HFPullCollectionView) {
        delegate?.scheduleViewDidStartRefresh()
    }
}

extension HFHomeSchudulesView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(dayCount) + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HFHomeScheduleHeaderCell
            cell.label.text = dayNamesList[indexPath.row]
            return cell
        } else if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath) as! HFHomeScheduleTitleCell
            cell.label.text = timeNamesList[indexPath.section]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bodyCell", for: indexPath) as! HFHomeScheduleBodyCell
            if let result = prepareCourseForIndex(indexPath) {
                if !result.isDouble {
                    cell.setupWithModel(result.models)
                }
                
            }
            return cell
        }
    }
    
    
}

extension HFHomeSchudulesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width  = (ScreenWidth - 30) / dayCount - 1
        var height:CGFloat = 110
        
        if indexPath.row == 0 {
            width = 30
        }
        
        if indexPath.section == 0 {
            height = 40
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}
