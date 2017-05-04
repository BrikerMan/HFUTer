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
    
    fileprivate var scheduleView   : HFScheduleView!
    fileprivate var weekSelectView : HFHomeScheduleSelectWeekView!
    
    fileprivate var isSelectWeekViewShowing = false
    
    fileprivate lazy var actionsView: HFScheduleActionsView = {
        let actions = HFScheduleActionsView()
        actions.delegate = self
        self.view.addSubview(actions)
        actions.snp.makeConstraints {
            $0.edges.equalTo(self.view).inset(UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        }
        return actions
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        viewModel.controller = self
        navBarView.backgroundColor = HFTheme.TintColor
        AnalyseManager.OpenSchudule.record()
    }
    
    @IBAction func onAddScheduleButtonPressed(_ sender: Any) {
        actionsView.show()
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
        loadSchedule()
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
                runOnMainThread {
                    self.scheduleView.setup(with: result, week: week)
                    self.scheduleView.scrollView.mj_header.endRefreshing()
                }
            }
            Hud.dismiss()
        }
    }
    
    // MARK: Animations
    func showOrHideSelectWeekView() {
        isSelectWeekViewShowing = !isSelectWeekViewShowing
        let offset = isSelectWeekViewShowing ? weekSelectView.height : 0
        let rotate = isSelectWeekViewShowing ? CGFloat(-Double.pi) : 0
        
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
        
        scheduleView = HFScheduleView()
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
        NotificationCenter.default.addObserver(self, selector: #selector(HFHomeVC.reloadSchedules), name: HFNotification.scheduleUpdated.get(), object: nil)
        
        
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
        weekSelectView.selectedWeek = currentWeek
    }
}

extension HFHomeVC: HFScheduleViewDelegate {
    func scheduleViewDidStartRefresh() {
        let cache = UIAlertAction(title: "继续", style: .default) { (action) in
            self.viewModel.refreshSchedule(for: self.currentWeek) { result, error in
                if let error = error {
                    self.loadFromServer(with: error)
                } else {
                    runOnMainThread {
                        self.scheduleView.setup(with: result, week: self.currentWeek)
                        self.scheduleView.scrollView.mj_header.endRefreshing()
                    }
                }
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in
            runOnMainThread {
                self.scheduleView.scrollView.mj_header.endRefreshing()
            }
        }
        
        self.showAlert(title: "", message: "刷新课表将会导致对于【从服务器获取的课程】进行的自定义操作丢失，本地新增课程不受影响。", actions: [cache, cancel] )
    }
}

extension HFHomeVC: HFScheduleActionsViewDelegate {
    func actionsViewDidChooseCustomBack() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func actionsViewDidChooseAdd() {
        actionsView.hide()
        let vc = HFScheduleInfoViewController()
        self.push(vc)
    }
    
    func actionsViewDidChooseShare() {

    }
}


extension HFHomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DataEnv.settings.scheduleBackImage.value = pickedImage
            picker.dismissVC(completion: { })
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
