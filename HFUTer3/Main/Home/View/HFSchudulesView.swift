//
//  HFSchudulesView.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/12.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFSchudulesMacros {
    static var hourCellWidth : CGFloat = 30
    static var hourHeight    : CGFloat = (ScreenHeight - 100) / 11
    static var dayCellHeight : CGFloat = 40
}

class HFSchudulesView: HFXibView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var hoursView   = UIView()
    var dayView     = UIView()
    var contentView = UIView()
    
    var dayViews: [HFScheduleDayView] = []
    
    override func initFromXib() {
        super.initFromXib()
        setupFrame()
    }
    
    
    func reload(days: [[HFScheduleModel]] ) {
        let dayCount = 5
        dayViews.removeAll()
        for i in 0..<dayCount {
            let day = HFScheduleDayView()
            day.backgroundColor = UIColor.random().withAlphaComponent(0.5)
            contentView.addSubview(day)
            dayViews.append(day)
            
            day.snp.makeConstraints {
                $0.bottom.top.equalTo(contentView)
                if i == 0 {
                    $0.left.equalTo(contentView.snp.left)
                } else {
                    $0.width.equalTo(dayViews[i-1].snp.width)
                    $0.left.equalTo(dayViews[i-1].snp.right).offset(SeperatorHeight)
                }
                if i == dayCount - 1 {
                    $0.right.equalTo(contentView.snp.right)
                }
            }
            
            day.load(models: days[i])
        }
    }
    
    func setupFrame() {
        scrollView.addSubview(hoursView)
        scrollView.addSubview(dayView)
        scrollView.addSubview(contentView)
        
        hoursView.backgroundColor = HFTheme.flatColors[1].color
        dayView.backgroundColor   = HFTheme.flatColors[2].color
        contentView.backgroundColor = HFTheme.flatColors[3].color
        
        hoursView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(HFSchudulesMacros.dayCellHeight)
            $0.left.bottom.equalTo(scrollView)
            $0.width.equalTo(HFSchudulesMacros.hourCellWidth)
            $0.height.equalTo(HFSchudulesMacros.hourHeight * 11)
        }
        
        dayView.snp.makeConstraints {
            $0.top.right.equalTo(scrollView)
            $0.height.equalTo(HFSchudulesMacros.dayCellHeight)
            $0.left.equalTo(scrollView.snp.left).offset(HFSchudulesMacros.hourCellWidth)
            $0.right.equalTo(self.snp.right)
        }
        
        contentView.snp.makeConstraints {
            $0.right.equalTo(self)
            $0.bottom.equalTo(hoursView.snp.bottom)
            $0.left.equalTo(hoursView.snp.right)
            $0.top.equalTo(dayView.snp.bottom)
        }
    }
}
