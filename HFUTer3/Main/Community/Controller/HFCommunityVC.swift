//
//  HFCommunityVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFCommunityVC: HFBasicViewController {
    
    var lostAndFindRequest: HFGetCommunityLostAndFindRequest!
    var loveWallRequest   : HFGetCommunityLoveWallListRequest!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    fileprivate var lostfindView: HFCommunityHomeListView!
    fileprivate var loveWallView: HFCommunityHomeListView!
    
    var actionButton: UIButton!
    
    fileprivate var isLostAndFound      = true
    fileprivate var isActionListShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLoveListView), name: NSNotification.Name(rawValue: HFNotification.LoveWallModelUpdate.rawValue), object: nil)
    }
    
    
    func reloadLoveListView() {
        loveWallView.tableView.reloadData()
    }
    
    
    @IBAction func onSegmentControlleralueChanged(_ sender: UISegmentedControl) {
        let rect = CGRect(x: ScreenWidth * CGFloat(sender.selectedSegmentIndex), y: 0, width: ScreenWidth, height: ScreenHeight)
        scrollView.scrollRectToVisible(rect, animated: false)
        isLostAndFound = sender.selectedSegmentIndex == 0
    }
    
    @objc fileprivate func onActionButtonPressed() {
        if isLostAndFound {
            let vc = HFCommunityPostLostAndFoundVC()
            self.push(vc)
        } else {
            let vc = HFCommunityPostLoveWallVC()
            self.push(vc)
        }
    }
    
    fileprivate func onLikeButtonPressedOnCell(_ index: Int) {
        hud.showLoading("正在处理")
        let model = self.loveWallView.loveModels[index]
        HFBaseRequest.fire("/api/confession/favorite", method: HFBaseAPIRequestMethod.POST, params: ["id":model.id as AnyObject], succesBlock: { (request, resultDic) in
            model.favoriteCount += 1
            model.favorite = true
            self.loveWallView.tableView.reloadData()
            hud.dismiss()
            NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.LoveWallModelUpdate.rawValue), object: nil)
        }) { (request, error) in
            hud.showError(error)
        }
    }
    
    fileprivate func initUI() {
        lostfindView = HFCommunityHomeListView()
        lostfindView.delegate = self
        scrollView.addSubview(lostfindView)
        
        lostfindView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(scrollView)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-64-49)
        }
        
        loveWallView = HFCommunityHomeListView()
        loveWallView.delegate = self
        scrollView.addSubview(loveWallView)
        
        loveWallView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(scrollView)
            make.left.equalTo(lostfindView.snp.right)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-64-49)
        }
        
        actionButton = UIButton(type: UIButtonType.custom)
        self.view.addSubview(actionButton)
        actionButton.setImage(UIImage(named: "hf_comminity_action_button"), for: UIControlState())
        actionButton.addTarget(self, action: #selector(self.onActionButtonPressed), for: .touchUpInside)
        actionButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-10)
            make.right.equalTo(scrollView.snp.right).offset(-10)
        }
        
        
        actionButton.layer.masksToBounds =  false
        actionButton.layer.shadowColor = UIColor.darkGray.cgColor;
        actionButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        actionButton.layer.shadowOpacity = 1.0
    }
    
    fileprivate func initData() {
        lostAndFindRequest = HFGetCommunityLostAndFindRequest()
        lostAndFindRequest.callback = self
        
        
        loveWallRequest = HFGetCommunityLoveWallListRequest()
        loveWallRequest.callback = self
        loveWallRequest.loadData()
    }
    
}

extension HFCommunityVC: HFCommunityHomeListViewDelegate {
    
    func listView(_ listView: HFCommunityHomeListView, didChooseReplyButton index: Int) {
        let vc = HFCommunityContactLosterVC()
        vc.modelId = lostfindView.lostModels[index].id
        self.push(vc)
    }
    
    func listView(_ listView: HFCommunityHomeListView, didChooseOnLikeButton index: Int) {
        self.onLikeButtonPressedOnCell(index)
    }
    
    func listViewDidSelectedAtIndex(_ listView: HFCommunityHomeListView, index: Int) {
        if listView.style == .lostFind {

        } else {
            let vc = HFCommunityLoveWallDetailVC(nibName: "HFCommunityLoveWallDetailVC", bundle: nil)
            vc.mainModel = loveWallView.loveModels[index]
            self.push(vc)
        }
    }
    
    func listViewTableViewStartRefeshing(_ listView: HFCommunityHomeListView) {
        if listView.style == .lostFind {
            lostAndFindRequest.page = 0
            lostAndFindRequest.loadData()
        } else {
            loveWallRequest.page = 0
            loveWallRequest.loadData()
        }
    }
    
    func listViewTableViewStartLoadingMore(_ listView: HFCommunityHomeListView) {
        if listView.style == .lostFind {
            lostAndFindRequest.loadNextPage()
        } else {
            loveWallRequest.loadNextPage()
        }
    }
}

extension HFCommunityVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        print(manager.errorInfo)
        
    }
    
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        
        if let manager = manager as? HFGetCommunityLostAndFindRequest {
            let result =  HFGetCommunityLostAndFindRequest.handleData(manager.resultDic)
            if manager.page == 0 {
                lostfindView.lostModels.removeAll()
            }
            
            lostfindView.setupWithLostModel(result)
        }
        
        if let manager = manager as? HFGetCommunityLoveWallListRequest {
            let result =  HFGetCommunityLoveWallListRequest.handleData(manager.resultDic)
            if manager.page == 0 {
                loveWallView.loveModels.removeAll()
            }
            loveWallView.setupWithLoveModel(result)
        }
    }
}

extension HFCommunityVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x / ScreenWidth
        segmentController.selectedSegmentIndex = Int(x)
        isLostAndFound = Int(x) == 0
    }
}
