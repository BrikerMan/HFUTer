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
    
    let loveViewModel = HFCommunityLoveViewModel()
    let lostViewModel = HFCommunityLostViewModel()
    
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
        lostfindView.style = .lostFind
        lostfindView.isAllowDelete = true
        lostfindView.delegate = self
        scrollView.addSubview(lostfindView)
        
        
        loveWallView = HFCommunityHomeListView()
        loveWallView.isAllowDelete = true
        loveWallView.delegate = self
        loveWallView.style = .loveWall
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
        loveViewModel.isMine = true
        lostViewModel.isMine = true
        
        loveWallView.tableView.beginRefresh()
        lostfindView.tableView.beginRefresh()
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
            let vc = HFCommunityLoveWallDetailVC.instantiate()
            vc.mainModel = loveWallView.loveModels[index]
            self.push(vc)
        }
    }
    
    func listViewTableViewStartRefeshing(_ listView: HFCommunityHomeListView) {
        if listView.style == .lostFind {
            lostViewModel.loadFirstPage { (models) in
                self.lostfindView.lostModels.removeAll()
                self.lostfindView.setupWithLostModel(models)
            }
        } else {
            loveViewModel.loadFirstPage { (models) in
                self.loveWallView.loveModels.removeAll()
                self.loveWallView.setupWithLoveModel(models)
            }
        }
    }
    
    func listViewTableViewStartLoadingMore(_ listView: HFCommunityHomeListView) {
        if listView.style == .lostFind {
            lostViewModel.loadNextPage(completion: { (models) in
                self.lostfindView.setupWithLostModel(models)
            })
        } else {
            loveViewModel.loadNextPage(completion: { (models) in
                self.loveWallView.setupWithLoveModel(models)
            })
        }
    }
}

extension HFMinePublishVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x / ScreenWidth
        segmentController.selectedSegmentIndex = Int(x)
    }
}
