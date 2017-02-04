//
//  HFMinePublishVC.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/5/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMinePublishVC: HFBasicViewController {
   
    var loadingView: HFLoadingView!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topView: UIView!
    
    var lostfindView:HFCommunityHomeListView!
    var loveWallView:HFCommunityHomeListView!
    
    fileprivate var lostModels      : [HFComLostFoundModel] = []
    fileprivate var loveWallModels  : [HFComLoveWallListModel] = []
    
    fileprivate var lostAndFindRequest: HFGetCommunityLostAndFindRequest!
    fileprivate var loveWallRequest   : HFGetCommunityLoveWallListRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        
        topView.backgroundColor = HFTheme.TintColor
        AnalyseManager.SeeSelfPost.record()
    }
    
    @IBAction func onPopButtonPressed(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSegmentValueChanged(_ sender: AnyObject) {
        let x = CGFloat(segmentController.selectedSegmentIndex) * ScreenWidth
        let rect = CGRect(x: x, y: 0, width: ScreenWidth, height: ScreenHeight-64)
        scrollView.scrollRectToVisible(rect, animated: false)
    }
    
    override func updateTintColor() {
        topView.backgroundColor = HFTheme.TintColor
    }
    
    fileprivate func initUI() {
        automaticallyAdjustsScrollViewInsets = false
        
        lostfindView = HFCommunityHomeListView()
        lostfindView.isAllowDelete = true
        lostfindView.delegate = self
        scrollView.addSubview(lostfindView)
        

        loveWallView = HFCommunityHomeListView()
        loveWallView.isAllowDelete = true
        loveWallView.delegate = self
        scrollView.addSubview(loveWallView)
        
        loveWallView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(scrollView)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-64)
        }
        
        
        lostfindView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(scrollView)
            make.left.equalTo(loveWallView.snp.right)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-64)
        }
        
        loadingView = HFLoadingView()
        view.addSubview(loadingView!)
        loadingView!.snp.makeConstraints({ (make) in make.edges.equalTo(view).inset(UIEdgeInsetsMake(64, 0, 0, 0))
        })
    }
    
    fileprivate func initData() {
        lostAndFindRequest = HFGetCommunityLostAndFindRequest()
        lostAndFindRequest.isMine = true
        lostAndFindRequest.callback = self
        lostAndFindRequest.loadData()
        
        
        loveWallRequest = HFGetCommunityLoveWallListRequest()
        loveWallRequest.isMine = true
        loveWallRequest.callback = self
        loveWallRequest.loadData()
    }
}

extension HFMinePublishVC: HFBaseAPIManagerCallBack {
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
            let result =  HFGetCommunityLoveWallListRequest.handleData(manager.resultDic, isMine: true)
            if manager.page == 0 {
                loveWallView.loveModels.removeAll()
            }
            loveWallView.setupWithLoveModel(result)
        }
    }
}

extension HFMinePublishVC: HFCommunityHomeListViewDelegate {
    func listView(_ listView: HFCommunityHomeListView, didChooseOnLikeButton index: Int) {
        
    }
    
    func listView(_ listView: HFCommunityHomeListView, didChooseReplyButton index: Int) {

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

extension HFMinePublishVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x / ScreenWidth
        segmentController.selectedSegmentIndex = Int(x)
    }
}
