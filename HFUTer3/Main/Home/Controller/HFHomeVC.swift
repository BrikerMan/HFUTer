//
//  HFHomeVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import LTMorphingLabel

class HFHomeVC: HFBasicViewController{
    
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var navTitleLabel: LTMorphingLabel!
    @IBOutlet weak var navTitleIconView: UIImageView!
    
    var loadingView: HFLoadingView?
    
    var viewModel = HFParseVidewModel()
    
    fileprivate var currentWeek = 0
    
    fileprivate var scheduleView : HFHomeSchudulesView!
    fileprivate var weekSelectView: HFHomeScheduleSelectWeekView!
    
    fileprivate var isSelectWeekViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        
        navBarView.backgroundColor = HFTheme.TintColor
        AnalyseManager.OpenSchudule.record()
    }
    
    
    @objc fileprivate func afterUserLogin(_ sender:AnyObject) {
        loadSchedule()
    }
    
    @IBAction func onNavWeekSelectButtonPressed(_ sender: AnyObject) {
        showOrHideSelectWeekView()
    }
    
    @objc fileprivate func reloadSchedules() {
        scheduleView.reloadData()
    }
    
    override func updateTintColor() {
        navBarView.backgroundColor = HFTheme.TintColor
    }
    
    // MARK:- Load Data
    func loadSchedule() {
        let week = currentWeek
        Hud.showLoading("正在加载课表")
        viewModel.fetchSchedule(for: week) { result, error in
            if let error = error {
                Hud.showError(error)
            } else {
                Hud.dismiss()
                self.scheduleView.setupWithCourses(result)
                self.scheduleView.setupWithWeek(week)
            }
        }
    }
    
    // MARK: Animations
    func showOrHideSelectWeekView() {
        isSelectWeekViewShowing = !isSelectWeekViewShowing
        let offset = isSelectWeekViewShowing ? weekSelectView.height : 0
        let rotate = isSelectWeekViewShowing ? CGFloat(-M_PI) : 0
        
        weekSelectView.snp.updateConstraints { (make) in
            make.bottom.equalTo(navBarView.snp.bottom).offset(offset)
        }
        
        view.bringSubview(toFront: weekSelectView)
        view.bringSubview(toFront: navBarView)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            self.navTitleIconView.transform = CGAffineTransform(rotationAngle: rotate)
        },completion: nil)
    }
    
    
    
    // MARK: - Init
    fileprivate func initUI() {
        navTitleLabel.morphingEffect = LTMorphingEffect.evaporate
        
        scheduleView = HFHomeSchudulesView()
        scheduleView.delegate = self
        view.addSubview(scheduleView)
        
        scheduleView.snp.makeConstraints { (make) in
            make.edges.equalTo(containView)
        }
        
        weekSelectView = HFHomeScheduleSelectWeekView()
        weekSelectView.delegate = self
        
        view.addSubview(weekSelectView)
        
        weekSelectView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.bottom.equalTo(navBarView.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(weekSelectView.height)
        }
        
        view.bringSubview(toFront: navBarView)
    }
    
    
    fileprivate func initData() {
        NotificationCenter.default.addObserver(self, selector: #selector(HFHomeVC.afterUserLogin(_:)), name: NSNotification.Name(rawValue: HFUserLoginNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HFHomeVC.reloadSchedules), name: NSNotification.Name(rawValue: HFNotification.SettingScheduleRelatedUpdate.rawValue), object: nil)
        
        
        currentWeek = DataEnv.currentWeek
        
        if currentWeek == 0 {
            navTitleLabel.text = "全部"
        } else {
            navTitleLabel.text = "第 \(currentWeek) 周"
        }
        navTitleLabel.setNeedsLayout()
        navTitleLabel.layoutIfNeeded()
        
        
        if DataEnv.isLogin {
            loadSchedule()
        }
        weekSelectView.selectedWeek = currentWeek
    }
}

extension HFHomeVC: HFHomeSchudulesViewDelegate {
    func scheduleViewDidStartRefresh() {
        viewModel.refreshSchedule(for: currentWeek) { result, error in
            if let error = error {
                Hud.showError(error)
            } else {
                runOnMainThread {
                    self.scheduleView.setupWithCourses(result)
                    self.scheduleView.collectionView.endRefresh()
                    self.scheduleView.setupWithWeek(self.currentWeek)
                }
            }
        }
    }
    
}

extension HFHomeVC: HFHomeScheduleSelectWeekViewDelegate {
    func selectWeekViewDidSelectedOnWeek(weekIndex index: Int) {
        if index == 0 {
            navTitleLabel.text = "全部"
        } else {
            navTitleLabel.text = "第 \(index) 周"
        }
        showOrHideSelectWeekView()
        currentWeek = index
        loadSchedule()
        
        AnalyseManager.ChangeWeeks.record()
    }
}
