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
    
    var viewModel = HFScheduleViewModel()
    
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
        loadScheduleFromServer()
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
        viewModel.loadData(week: currentWeek) { (result) in
            self.scheduleView.setupWithCourses(result)
            self.scheduleView.setupWithWeek(week)
        }
    }
    
    
    fileprivate func loadScheduleFromServer() {
        
        loadingView = HFLoadingView()
        containView.addSubview(loadingView!)
        loadingView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(containView)
        })
        
        
        let getScheduleRequest = HFHomeGetCourseListRequest()
        getScheduleRequest.callback = self
        getScheduleRequest.loadData()
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
        let getScheduleRequest = HFHomeGetCourseListRequest()
        getScheduleRequest.isUpdate = true
        getScheduleRequest.callback = self
        getScheduleRequest.loadData()
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


extension HFHomeVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        loadingView?.hide()
        HFHomeViewModel().prepareScheuldeModels(dic: manager.resultDic)
        if let result = HFCourseModel.readCourses(forWeek: currentWeek) {
            scheduleView.setupWithCourses(result)
        }
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}
