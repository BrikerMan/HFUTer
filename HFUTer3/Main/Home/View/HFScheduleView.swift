//
//  FLScheduleView.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/26.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit

fileprivate class kSchedule {
    static var day = 5
    static var cellWidth  = (ScreenWidth - 30) / CGFloat(kSchedule.day)
    static var cellHeight = (ScreenHeight - 64 - 49) / 11
    
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
    
    var scheduleCells : [String: HFScheduleViewCell] = [:]
    var topViewCells  : [HFScheduleTopView] = []
    
    var schedules: [HFScheduleModel] = []
    
    var delegate: HFScheduleViewDelegate?
    
    override func initSetup() {
        setupBaseViews()
        
        setupLeftViews()
        setupContentView()
        
        DataEnv.settings.weekendSchedule.asObservable().subscribe(onNext: { [weak self] (element) in
            kSchedule.day = element ? 7 : 5
            kSchedule.cellWidth  = (ScreenWidth - 30) / CGFloat(kSchedule.day)
            self?.setupTopView()
            self?.setup(with: self?.schedules ?? [])
        }).addDisposableTo(disposeBag)
        
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.delegate?.scheduleViewDidStartRefresh()
        })
    }
    
    func setup(with schedules: [HFScheduleModel]) {
        self.schedules = schedules
        let viewModels = HFCourceViewModel.group(schedules: schedules)
        drawScheduleView(viewModels: viewModels)
    }
    
    fileprivate func setupBaseViews() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        scrollView.addSubview(topView)
        scrollView.addSubview(leftView)
        scrollView.addSubview(containerView)
        
        topView.snp.makeConstraints {
            $0.left.top.right.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(kSchedule.topHeight)
        }
        
        leftView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.bottom.equalTo(scrollView)
            $0.width.equalTo(kSchedule.leftWidth)
            $0.height.equalTo(scrollView.snp.height)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.equalTo(leftView.snp.right)
            $0.right.bottom.equalTo(scrollView)
        }
        
        scrollView.backgroundColor = HFTheme.BlackAreaColor
        topView.backgroundColor    = HFTheme.BlackAreaColor
        leftView.backgroundColor   = HFTheme.BlackAreaColor
        containerView.backgroundColor = UIColor.white
    }
    
    fileprivate func setupTopView() {
        topViewCells.removeAll()
        topView.removeSubviews()
        
        for i in 0...kSchedule.day {
            let cell = HFScheduleTopView()
            cell.titleLabel.text = kSchedule.dayNamesList[i]
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
        let cellHeight = (ScreenHeight - 64 - 49) / 11
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
