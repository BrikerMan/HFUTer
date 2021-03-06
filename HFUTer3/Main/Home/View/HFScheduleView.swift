//
//  FLScheduleView.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/26.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

fileprivate class kSchedule {
    static var day = 5
    static var cellWidth  = (ScreenWidth - 30) / CGFloat(kSchedule.day)
    static var cellHeight = (ScreenHeight - NavbarHeight - TabbarHeight - topHeight) / 11
    
    static let leftWidth: CGFloat = 30
    static let topHeight: CGFloat = 40
    
    static let dayNamesList = ["","周一","周二","周三","周四","周五","周六","周日"]
}

protocol HFScheduleViewDelegate: class {
    func scheduleViewDidStartRefresh()
}

class HFScheduleView: HFView {
    var scrollView    = UIScrollView()
    var topView       = UIView()
    var leftView      = UIView()
    
    var containerView = UIView()
    var imageView     = UIImageView()
    
    var scheduleCells : [String: HFScheduleViewCell] = [:]
    var topViewCells  : [HFScheduleTopView] = []
    
    var schedules: [HFScheduleModel] = []
    var week = 0
    
    fileprivate var shareBottom = HFScheduleShareBottonView()
    
    var delegate: HFScheduleViewDelegate?
    
    override func initSetup() {
        setupBaseViews()
        
        setupLeftViews()
        setupContentView()
        
        DataEnv.settings.weekendSchedule.asObservable().subscribe(onNext: { [weak self] (element) in
            kSchedule.day = element ? 7 : 5
            kSchedule.cellWidth  = (ScreenWidth - 30) / CGFloat(kSchedule.day)
            self?.setupTopView()
            self?.setup(with: self?.schedules ?? [], week: self?.week ?? 0)
        }).disposed(by: disposeBag)
        
        
        DataEnv.settings.scheduleShowDayDate.asObservable().subscribe(onNext: { [weak self] (element) in
            self?.setup(week: self?.week ?? 0)
        }).disposed(by: disposeBag)
        
        
        DataEnv.settings.scheduleBackImage.asObservable().subscribe(onNext: { [weak self] (element) in
            if let image = element {
                self?.topView.backgroundColor  = HFTheme.BlackAreaColor.withAlphaComponent(0.2)
                self?.leftView.backgroundColor = HFTheme.BlackAreaColor.withAlphaComponent(0.2)
                self?.imageView.image          = image
            } else {
                self?.topView.backgroundColor  = HFTheme.BlackAreaColor
                self?.leftView.backgroundColor = HFTheme.BlackAreaColor
                self?.imageView.image = nil
            }
            self?.updateSave()
        }).disposed(by: disposeBag)
        
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.delegate?.scheduleViewDidStartRefresh()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTintColorUpdated), name: .tintColorUpdated, object: nil)
    }
    
    func updateSave() {
        let file = DataEnv.settings.filePath.appendingPathComponent("backImage.jpg")
        if let image = DataEnv.settings.scheduleBackImage.value,
            let data = UIImageJPEGRepresentation(image, 0.8) {
            try? data.write(to: file)
        } else {
            try? FileManager.default.removeItem(at: file)
        }
    }
    
    @objc fileprivate func onTintColorUpdated() {
        setup(week: week)
    }
    
    func setup(with schedules: [HFScheduleModel], week: Int) {
        self.schedules = schedules
        let viewModels = HFCourceViewModel.group(schedules: schedules)
        drawScheduleView(viewModels: viewModels)
        setup(week: week)
    }
    
    func setup(week: Int) {
        self.week = week
        let dates = DataHelper.getDaysListForWeek(week)
        
        for (index, cell) in topViewCells.enumerated() {
            let att = NSMutableAttributedString()
            
            var color: UIColor
            if week == DataEnv.currentWeek, Date().getDayOfWeek() == index {
                color = HFTheme.TintColor
            } else {
                color = HFTheme.DarkTextColor
            }
            
            let font  = UIFont.systemFont(ofSize: 12)
            let boldfont  = UIFont.boldSystemFont(ofSize: 12)
            
            let dayName = NSAttributedString(string: kSchedule.dayNamesList[index],
                                             attributes: [
                                                NSAttributedStringKey.font: boldfont,
                                                NSAttributedStringKey.foregroundColor: color])
            att.append(dayName)
            if DataEnv.settings.scheduleShowDayDate.value {
                
                let dateAtt = NSAttributedString(string: "\n\(dates[index])",
                    attributes: [
                        NSAttributedStringKey.font: font,
                        NSAttributedStringKey.foregroundColor: color])
                att.append(dateAtt)
            }
            
            cell.titleLabel.attributedText = att
        }
    }
    
//    public func saveToImage(completion: @escaping (UIImage?)->Void)  {
//        shareBottom.snp.updateConstraints {
//            $0.height.equalTo(110)
//        }
//        runOnMainThread {
//            self.layoutIfNeeded()
//        }
//        
////        scrollView.swContentCapture { (image) in
////            completion(image)
////            self.shareBottom.snp.updateConstraints {
////                $0.height.equalTo(0)
////            }
////            runOnMainThread {
////                self.layoutIfNeeded()
////            }
////        }
//        completion(scrollView.screenshot())
//                    self.shareBottom.snp.updateConstraints {
//                        $0.height.equalTo(0)
//                    }
//                    runOnMainThread {
//                        self.layoutIfNeeded()
//                    }
//    }
    
    
    
    fileprivate func setupBaseViews() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(topView)
        scrollView.addSubview(leftView)
        scrollView.addSubview(containerView)
        scrollView.addSubview(shareBottom)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        topView.snp.makeConstraints {
            $0.left.top.right.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(kSchedule.topHeight)
        }
        
        leftView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.equalTo(scrollView)
            $0.width.equalTo(kSchedule.leftWidth)
            $0.height.equalTo(ScreenHeight - NavbarHeight - TabbarHeight - kSchedule.topHeight)
        }
        
        shareBottom.snp.makeConstraints {
            $0.top.equalTo(leftView.snp.bottom)
            $0.left.right.equalTo(scrollView)
            $0.height.equalTo(0)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.equalTo(leftView.snp.right)
            $0.right.bottom.equalTo(scrollView)
        }
        

        containerView.backgroundColor = UIColor.clear
        
        imageView.snp.makeConstraints {
            $0.top.left.right.equalTo(scrollView)
            $0.bottom.equalTo(leftView.snp.bottom)
        }
        
    }
    
    fileprivate func setupTopView() {
        topViewCells.removeAll()
        topView.removeSubviews()
        
        for i in 0...kSchedule.day {
            let cell = HFScheduleTopView()
            //            cell.titleLabel.text = kSchedule.dayNamesList[i]
            topView.addSubview(cell)
            
            cell.snp.makeConstraints {
                $0.top.equalTo(topView)
                $0.height.equalTo(topView)
                
                if i == 0 {
                    $0.width.equalTo(kSchedule.leftWidth)
                    $0.left.equalTo(topView.snp.left)
                } else {
                    $0.width.equalTo(kSchedule.cellWidth)
                    $0.left.equalTo(topView.snp.left).offset(CGFloat(i - 1) * kSchedule.cellWidth + 30)
                }
                
            }
            topViewCells.append(cell)
        }
    }
    
    fileprivate func setupLeftViews() {
        for i in 0..<11 {
            let cell = HFScheduleLeftView()
            cell.titleLabel.text = "\(i+1)"
            leftView.addSubview(cell)
            
            cell.snp.makeConstraints {
                $0.width.equalTo(leftView)
                $0.height.equalTo(kSchedule.cellHeight)
                $0.left.equalTo(leftView)
                $0.top.equalTo(leftView.snp.top).offset(CGFloat(i) * kSchedule.cellHeight)
            }
        }
    }
    
    fileprivate func setupContentView() {
        let cellHeight = (ScreenHeight - NavbarHeight - TabbarHeight) / 11
        for i in 1..<11 {
            let seperator = UIImageView(image: UIImage(named: "hf_widget_seperator_line"))
            containerView.addSubview(seperator)
            seperator.alpha = 0.2
            seperator.snp.makeConstraints {
                $0.left.right.equalTo(containerView)
                $0.top.equalTo(containerView.snp.top).offset(CGFloat(i) * cellHeight)
                $0.height.equalTo(HFTheme.SeperatorHeight)
            }
        }
    }
    
    fileprivate func drawScheduleView(viewModels: [HFCourceViewModel]) {
        scheduleCells.removeAll()
        containerView.removeSubviews()
        
        for model in viewModels {
            if let cell = scheduleCells["\(model.day)-\(model.start)"] {
                cell.add(model: model)
            } else {
                let cell = HFScheduleViewCell()
                cell.setup(model: model)
                containerView.addSubview(cell)
                
                cell.snp.makeConstraints {
                    $0.left.equalTo(containerView.snp.left).offset(kSchedule.cellWidth * CGFloat(model.day))
                    $0.top.equalTo(containerView.snp.top).offset(kSchedule.cellHeight * CGFloat(model.start))
                    $0.height.equalTo(kSchedule.cellHeight * model.duration.toCGFloat)
                    $0.width.equalTo(kSchedule.cellWidth)
                }
                scheduleCells["\(model.day)-\(model.start)"] = cell
            }
        }
    }
}

extension Date {
    func getDayOfWeek() -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let day = myCalendar.component(.weekday, from: self)
        if day == 1 {
            return 7
        } else {
            return day - 1
        }
    }
}

extension UIView {
    func screenshot() -> UIImage {
        
        if(self is UIScrollView) {
            let scrollView = self as! UIScrollView
            
            let savedContentOffset = scrollView.contentOffset
            let savedFrame = scrollView.frame
            
            UIGraphicsBeginImageContext(scrollView.contentSize)
            scrollView.contentOffset = .zero
            self.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            
            scrollView.contentOffset = savedContentOffset
            scrollView.frame = savedFrame
            
            return image!
        }
        
        UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
}
