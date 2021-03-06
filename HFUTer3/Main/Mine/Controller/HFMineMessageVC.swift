//
//  HFMineMessageVC.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/5/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFMineMessageVC: HFBasicViewController {

    var notifRequest    : HFGetMineNotifReqeust!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var verticalOffset: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var messageList: HFMineMessageListView!
    var notifList  : HFMineMessageListView!
    
    let viewModel = HFMineMessageViewModel()
    var loadingView: HFLoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        viewModel.loadMessageFirstPage()
            .then { json -> Void in
                
            }.catch { error in
                Hud.showError("")
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.RemoveBundge.rawValue), object: nil)
        
        AnalyseManager.SeeMessages.record()
    }
    
    @IBAction func onPopButtonPressed(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSegmentValueChanged(_ sender: AnyObject) {
        let sender = sender as! UISegmentedControl
        let x = CGFloat(sender.selectedSegmentIndex) * ScreenWidth
        let rect = CGRect.init(x: x, y: 0, width: ScreenWidth, height: ScreenHeight - NavbarHeight)
        scrollView.scrollRectToVisible(rect, animated: false)
    }
    
    fileprivate func initUI() {
        topViewHeight.constant = NavbarHeight
        verticalOffset.constant = NavbarVerticalOffSet
        topView.backgroundColor = HFTheme.TintColor
        
        messageList = HFMineMessageListView()
        
        scrollView.addSubview(messageList)
        messageList.delegate = self
        messageList.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(scrollView)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-NavbarHeight)
        }
        
        notifList = HFMineMessageListView()
        notifList.isNotif = true
        scrollView.addSubview(notifList)
        
        notifList.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(scrollView)
            make.left.equalTo(messageList.snp.right)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-NavbarHeight)
        }
        
        loadingView = HFLoadingView()
        loadingView?.add(to: self.view)
    }
    
    override func updateTintColor() {
        topView.backgroundColor = HFTheme.TintColor
    }
    
    
    fileprivate func initData() {
        loadingView?.show()
        viewModel.loadMessageFirstPage()
            .then { result -> Void in
                self.messageList.messageList.removeAll()
                self.messageList.setupWithMessage(result)
                self.loadingView?.hide()
            }.catch { error in
                Hud.showError("")
        }
        notifRequest = HFGetMineNotifReqeust()
        notifRequest.callback = self
        notifRequest.loadData()
    }
}

extension HFMineMessageVC: HFMineMessageListViewDelegate {
    func tableViewStartLoadingMore() {
        viewModel.loadMessageNextPage()
            .then { result -> Void in
                self.messageList.setupWithMessage(result)
            }.catch { error in
                Hud.showError("")
        }
    }
}

extension HFMineMessageVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        if let manager = manager as? HFGetMineNotifReqeust {
            let result = HFGetMineNotifReqeust.handleData(manager.resultDic)
            notifList.setupWithNotif(result)
        }
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        
    }
}
