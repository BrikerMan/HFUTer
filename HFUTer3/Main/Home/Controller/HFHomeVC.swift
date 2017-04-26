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
    
    @IBOutlet weak var navBarView       : UIView!
    @IBOutlet weak var containView      : UIView!
    @IBOutlet weak var navTitleLabel    : LTMorphingLabel!
    @IBOutlet weak var navTitleIconView : UIImageView!
    
    var loadingView: HFLoadingView?
    
    var viewModel = HFParseViewModel()
    
    fileprivate var currentWeek = 0
    
//    fileprivate var scheduleView   : HFHomeSchudulesView!
//    fileprivate var weekSelectView : HFHomeScheduleSelectWeekView!
    
    fileprivate var isSelectWeekViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        viewModel.controller = self
        navBarView.backgroundColor = HFTheme.TintColor
        AnalyseManager.OpenSchudule.record()
    }
    
    
    @objc fileprivate func afterUserLogin(_ sender:AnyObject) {
        HFParseViewModel.info = nil
        Hud.showLoading("正在加载课表")
        loadSchedule()
    }
    
    @IBAction func onNavWeekSelectButtonPressed(_ sender: AnyObject) {
        showOrHideSelectWeekView()
    }
    
    @objc fileprivate func reloadSchedules() {
//        scheduleView.reloadData()
    }
    
    override func updateTintColor() {
        navBarView.backgroundColor = HFTheme.TintColor
    }
    
    // MARK:- Load Data
    func loadSchedule() {
        let week = currentWeek
        
        viewModel.fetchSchedule(for: week) { result, error in
            if let error = error {
                self.showEduError(error: error)
            } else {
                Logger.debug(result.description)
            }
            Hud.dismiss()
        }
    }
    
    // MARK: Animations
    func showOrHideSelectWeekView() {
        isSelectWeekViewShowing = !isSelectWeekViewShowing
//        let offset = isSelectWeekViewShowing ? weekSelectView.height : 0
//        let rotate = isSelectWeekViewShowing ? CGFloat(-Double.pi) : 0
//        
//        weekSelectView.snp.updateConstraints { (make) in
//            make.bottom.equalTo(navBarView.snp.bottom).offset(offset)
//        }
//        
//        view.bringSubview(toFront: weekSelectView)
//        view.bringSubview(toFront: navBarView)
//        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
//            self.view.layoutIfNeeded()
//            self.navTitleIconView.transform = CGAffineTransform(rotationAngle: rotate)
//        },completion: nil)
    }
    
    func loadFromServer(with error1: String) {
        let cache = UIAlertAction(title: "读取服务器缓存", style: .default) { (action) in
            Hud.showLoading()
            self.viewModel.fetchScheduleFromServer()
                .then { Void -> Void in
                    Hud.dismiss()
                    self.showEduError(error: error1)
            }.catch { error in
                Hud.dismiss()
                if error.isFullfill {
                    self.loadSchedule()
                } else {
                    self.showEduError(error: error1)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in }
        
        self.showAlert(title: "获取数据失败", message: "可能是密码错误或者教务系统崩溃，如果此前已经成功获取过信息，可以尝试获取 HFUTer 服务器缓存数据。", actions: [cache, cancel] )
    }
    
    
    
    // MARK: - Init
    fileprivate func initUI() {
        navTitleLabel.morphingEffect = LTMorphingEffect.evaporate
        
//        scheduleView = HFHomeSchudulesView()
//        scheduleView.delegate = self
//        view.addSubview(scheduleView)
//        
//        scheduleView.snp.makeConstraints { (make) in
//            make.edges.equalTo(containView)
//        }
//        
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
            Hud.showLoading("正在加载课表")
            loadSchedule()
        }
//        weekSelectView.selectedWeek = currentWeek
    }
}

//extension HFHomeVC: HFHomeSchudulesViewDelegate {
//    func scheduleViewDidStartRefresh() {
//        viewModel.refreshSchedule(for: currentWeek) { result, error in
//            if let error = error {
//                self.loadFromServer(with: error)
//            } else {
//                self.scheduleView.setupWithCourses(result)
//                self.scheduleView.setupWithWeek(self.currentWeek)
//            }
//            runOnMainThread {
//                self.scheduleView.collectionView.endRefresh()
//            }
//        }
//    }
//    
//}
//
//extension HFHomeVC: HFHomeScheduleSelectWeekViewDelegate {
//    func selectWeekViewDidSelectedOnWeek(weekIndex index: Int) {
//        if index == 0 {
//            navTitleLabel.text = "全部"
//        } else {
//            navTitleLabel.text = "第 \(index) 周"
//        }
//        showOrHideSelectWeekView()
//        currentWeek = index
//        loadSchedule()
//        
//        AnalyseManager.ChangeWeeks.record()
//    }
//}
