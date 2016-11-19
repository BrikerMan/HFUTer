//
//  HFPullCollectionView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import MJRefresh

protocol HFPullCollectionViewPullDelegate :class{
    func pullCollectionViewStartRefreshing(_ collectionView: HFPullCollectionView)
}

class HFPullCollectionView: UICollectionView {

    /// 下来刷新回调
    weak var pullDelegate: HFPullCollectionViewPullDelegate?
    
    /// 是否在刷新
    var isRefreshing = false
    
    /**
     开始下来刷新
     */
    func beginRefresh() {
        isRefreshing = true
        mj_header.beginRefreshing()
    }
    
    /**
     结束下拉刷新
     */
    func endRefresh() {
        isRefreshing = false
        mj_header.endRefreshing()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addRefreshView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addRefreshView()
    }
    
    /**
     初始化的时候有下拉刷新
     */
    fileprivate func addRefreshView() {
        self.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.isRefreshing = true
            self.pullDelegate?.pullCollectionViewStartRefreshing(self)
        })
    }
}
