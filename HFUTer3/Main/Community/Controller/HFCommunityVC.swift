//
//  HFCommunityVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFCommunityVC: HFBasicViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var verticalOffset: NSLayoutConstraint!
    
    fileprivate var loveWallView: HFCommunityHomeListView!
    fileprivate var loveWallHotView: HFCommunityHomeListView!
    fileprivate var lostfindView: HFCommunityHomeListView!
    
    fileprivate var loveWallNewViewModel = HFCommunityLoveViewModel()
    fileprivate var loveWallHotViewModel = HFCommunityLoveViewModel()
    fileprivate var lostfindViewModel    = HFCommunityLostViewModel()
    
    fileprivate var isLostAndFound      = false
    fileprivate var isActionListShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLoveListView), name: NSNotification.Name(rawValue: HFNotification.LoveWallModelUpdate.rawValue), object: nil)
        
        topViewHeight.constant = CGFloat(NavbarHeight)
        verticalOffset.constant = CGFloat(NavbarVerticalOffSet)
    }
    
    
    @objc func reloadLoveListView() {
        loveWallView.tableView.reloadData()
    }
    
    
    @IBAction func onSegmentControlleralueChanged(_ sender: UISegmentedControl) {
        let rect = CGRect(x: ScreenWidth * CGFloat(sender.selectedSegmentIndex), y: 0, width: ScreenWidth, height: ScreenHeight-NavbarHeight-TabbarHeight)
        scrollView.scrollRectToVisible(rect, animated: false)
        isLostAndFound = sender.selectedSegmentIndex == 2
    }
    
    @IBAction fileprivate func onActionButtonPressed() {
        if isLostAndFound {
            let vc = HFCommunityPostLostAndFoundVC()
            self.push(vc)
        } else {
            let vc = HFCommunityPostLoveWallVC()
            self.push(vc)
        }
    }
    
    override func updateTintColor() {
        topView.backgroundColor = HFTheme.TintColor
    }
    
    fileprivate func onLikeButtonPressedOnCell(_ index: Int) {
        hud.showLoading("正在处理")
        let model = self.loveWallView.loveModels[index]
        HFBaseRequest.fire("/api/confession/favorite", method: HFBaseAPIRequestMethod.POST, params: ["id":model.id], succesBlock: { (request, resultDic) in
            model.favoriteCount += 1
            model.favorite.value = true
//            self.loveWallView.tableView.reloadData()
            hud.dismiss()
            NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.LoveWallModelUpdate.rawValue), object: nil)
        }) { (request, error) in
            hud.showError(error)
        }
    }
    
    fileprivate func initUI() {
        topView.backgroundColor = HFTheme.TintColor
        
        
        loveWallView = HFCommunityHomeListView()
        loveWallView.delegate = self
        scrollView.addSubview(loveWallView)
        
        loveWallHotView = HFCommunityHomeListView()
        loveWallHotView.isHot = true
        loveWallHotView.delegate = self
        scrollView.addSubview(loveWallHotView)
        
        lostfindView = HFCommunityHomeListView()
        lostfindView.delegate = self
        scrollView.addSubview(lostfindView)
        
        
        loveWallView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(scrollView)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-NavbarHeight-TabbarHeight)
        }
        
        loveWallHotView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.equalTo(loveWallView.snp.right)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-NavbarHeight-TabbarHeight)
        }
        
        lostfindView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(scrollView)
            make.left.equalTo(loveWallHotView.snp.right)
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight-NavbarHeight-TabbarHeight)
        }
    }
    
    fileprivate func initData() {
        loveWallNewViewModel.type = .loveWall
        loveWallNewViewModel.loadFirstPage { [weak self] (models) in
            self?.loveWallView.loveModels.removeAll()
            self?.loveWallView.setupWithLoveModel(models)
        }
        
        loveWallHotViewModel.type = .loveWallHot
        loveWallHotViewModel.loadFirstPage { [weak self] (models) in
            self?.loveWallHotView.loveModels.removeAll()
            self?.loveWallHotView.setupWithLoveModel(models)
        }
        
        lostfindViewModel.loadFirstPage { [weak self] (model) in
            self?.lostfindView.lostModels.removeAll()
            self?.lostfindView.setupWithLostModel(model)
        }
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
            if segmentController.selectedSegmentIndex == 0 {
                vc.mainModel = loveWallView.loveModels[index]
            } else {
                vc.mainModel = loveWallHotView.loveModels[index]
            }
            self.push(vc)
        }
    }
    
    func listViewTableViewStartRefeshing(_ listView: HFCommunityHomeListView) {
        if listView.style == .lostFind {
            lostfindViewModel.loadFirstPage { [weak self] (model) in
                self?.lostfindView.lostModels.removeAll()
                self?.lostfindView.setupWithLostModel(model)
            }
        } else {
            if listView.isHot {
                loveWallHotViewModel.loadFirstPage { [weak self] (models) in
                    self?.loveWallHotView.loveModels.removeAll()
                    self?.loveWallHotView.setupWithLoveModel(models)
                }
            } else {
                loveWallNewViewModel.loadFirstPage { [weak self] (models) in
                    self?.loveWallView.loveModels.removeAll()
                    self?.loveWallView.setupWithLoveModel(models)
                }
            }
        }
        
    }
    
    func listViewTableViewStartLoadingMore(_ listView: HFCommunityHomeListView) {
        if listView.style == .lostFind {
            lostfindViewModel.loadNextPage { [weak self] (model) in
                self?.lostfindView.setupWithLostModel(model)
            }
        } else {
            if listView.isHot {
                loveWallHotViewModel.loadNextPage { [weak self] (models) in
                    self?.loveWallHotView.setupWithLoveModel(models)
                }
            } else {
                loveWallNewViewModel.loadNextPage { [weak self] (models) in
                    self?.loveWallView.setupWithLoveModel(models)
                }
            }
        }
    }
}

extension HFCommunityVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x / ScreenWidth
        segmentController.selectedSegmentIndex = Int(x)
        isLostAndFound = Int(x) != 0
    }
}
