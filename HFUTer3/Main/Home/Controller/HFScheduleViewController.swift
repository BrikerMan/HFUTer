//
//  HFScheduleViewController.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/12.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import LTMorphingLabel

class HFScheduleViewController: UIViewController {
    
    @IBOutlet weak var navBarView       : UIView!
    @IBOutlet weak var containView      : UIView!
    @IBOutlet weak var navTitleLabel    : LTMorphingLabel!
    @IBOutlet weak var navTitleIconView : UIImageView!
    
    var viewModel = HFParseViewModel()
    
    fileprivate var currentWeek = 0
    fileprivate var isWeekViewShowing = false
    
//    fileprivate var scheduleView: HFSchudulesView!
//    fileprivate var weekSelectView : HFHomeScheduleSelectWeekView!
    
    // MARK: Events
    @IBAction func onNavWeekSelectButtonPressed(_ sender: AnyObject) {
        showOrHideSelectWeekView()
    }
    
    
    
    fileprivate func loadSchedules() {
        let days = HFScheduleModel.read(for: 1)
//        scheduleView.reload(days: days)
    }
    
    
    // MARK: Animations
    func showOrHideSelectWeekView() {
        isWeekViewShowing = !isWeekViewShowing
//        let offset = isWeekViewShowing ? weekSelectView.height : 0
        let rotate = isWeekViewShowing ? CGFloat(-Double.pi) : 0
        
//        weekSelectView.snp.updateConstraints { (make) in
//            make.bottom.equalTo(navBarView.snp.bottom).offset(offset)
//        }
//        
//        view.bringSubview(toFront: weekSelectView)
        view.bringSubview(toFront: navBarView)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            self.navTitleIconView.transform = CGAffineTransform(rotationAngle: rotate)
        },completion: nil)
    }
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSchedules()
    }
    
    
    
    
    fileprivate func setupUI() {
        navTitleLabel.morphingEffect = LTMorphingEffect.evaporate
//        weekSelectView = HFHomeScheduleSelectWeekView()
//        weekSelectView.delegate = self
//        
//        view.addSubview(weekSelectView)
//        
//        weekSelectView.snp.makeConstraints { (make) in
//            make.left.equalTo(view.snp.left)
//            make.bottom.equalTo(navBarView.snp.bottom)
//            make.width.equalTo(view.snp.width)
//            make.height.equalTo(weekSelectView.height)
//        }
//        
//        
//        scheduleView = HFSchudulesView()
//        view.addSubview(scheduleView)
//        
//        scheduleView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0))
//        }
        
        view.bringSubview(toFront: navBarView)
    }
}

//extension HFScheduleViewController: HFHomeScheduleSelectWeekViewDelegate {
//    func selectWeekViewDidSelectedOnWeek(weekIndex index: Int) {
//        if index == 0 {
//            navTitleLabel.text = "全部"
//        } else {
//            navTitleLabel.text = "第 \(index) 周"
//        }
//        showOrHideSelectWeekView()
//        currentWeek = index
//        
//        
//        AnalyseManager.ChangeWeeks.record()
//    }
//}
//
