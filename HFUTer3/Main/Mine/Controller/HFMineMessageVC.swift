//
//  HFMineMessageVC.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/5/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFMineMessageVC: HFBasicViewController {
    
    var messageRequest  : HFGetMineMessageRequest!
    var notifRequest    : HFGetMineNotifReqeust!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var messageList: HFMineMessageListView!
    var notifList  : HFMineMessageListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.RemoveBundge.rawValue), object: nil)
        
        AnalyseManager.SeeMessages.record()
    }
    
    @IBAction func onPopButtonPressed(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSegmentValueChanged(_ sender: AnyObject) {
        let sender = sender as! UISegmentedControl
        let x = CGFloat(sender.selectedSegmentIndex) * ScreenWidth
        let rect = CGRect.init(x: x, y: 0, width: ScreenWidth, height: ScreenHeight - 64)
        scrollView.scrollRectToVisible(rect, animated: false)
    }
    
    fileprivate func initUI() {
        messageList = HFMineMessageListView()
        
        scrollView.addSubview(messageList)
        
        messageList.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(scrollView)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-64)
        }
        
        notifList = HFMineMessageListView()
        notifList.isNotif = true
        scrollView.addSubview(notifList)
        
        notifList.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(scrollView)
            make.left.equalTo(messageList.snp.right)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-64)
        }
    }
    
    
    fileprivate func initData() {
        messageRequest = HFGetMineMessageRequest()
        messageRequest.callback = self
        messageRequest.loadData()
        
        notifRequest  = HFGetMineNotifReqeust()
        notifRequest.callback = self
        notifRequest.loadData()
    }
}

extension HFMineMessageVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        if let manager = manager as? HFGetMineNotifReqeust {
            let result = HFGetMineNotifReqeust.handleData(manager.resultDic)
            notifList.setupWithNotif(result)
        }
        
        if let manager = manager as? HFGetMineMessageRequest {
            let results = HFGetMineMessageRequest.handleData(manager.resultDic)
            messageList.setupWithMessage(results)
        }
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        
    }
}
