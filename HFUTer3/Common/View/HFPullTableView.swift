//
//  HFPullTableView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/25.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import MJRefresh
import DZNEmptyDataSet

protocol HFPullTableViewPullDelegate :class{
    func pullTableViewStartRefeshing(_ tableView:HFPullTableView)
    func pullTableViewStartLoadingMore(_ tableView:HFPullTableView)
}

/// 下拉刷新TableView
class HFPullTableView: UITableView {
    
    /// 下来刷新回调
    weak var pullDelegate: HFPullTableViewPullDelegate?
    
    /// 是否在刷新
    var isRefreshing = false
    
    var isNoMoreData = false
    
    /// 是否在加载更多
    var isLoadingMore  = false
    
    var emptyDataTitle = "暂无数据"
    
    func titleForEmptyForm() -> String {
        return emptyDataTitle
    }
    
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
    
    /**
     开始上拉加载更多
     */
    func beginLoadMore() {
        isLoadingMore = true
        mj_footer.beginRefreshing()
    }
    
    /**
     结束上拉加载更多
     */
    func endLoadMore() {
        isLoadingMore = false
        mj_footer.resetNoMoreData()
        mj_footer.endRefreshing()
    }
    
    /**
     结束上拉加载更多，并且标记没有更多
     */
    func endLoadMoreWithoutWithNoMoreData() {
        isLoadingMore = false
        isNoMoreData  = true
        mj_footer.endRefreshingWithNoMoreData()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initPullTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initPullTableView()
    }
    
    /**
     自动判断并且开始加载更多数据
     
     - parameter indexPath: 当前cell index
     - parameter dataCount: 总数据数量
     */
    func shouldStartPrefetch(at indexPath: IndexPath, dataCount: Int) {
        if indexPath.row == dataCount - 4 && !isNoMoreData && self.mj_footer != nil {
            self.beginLoadMore()
        }
    }
    
    /**
     初始化的时候有下拉刷新
     */
    fileprivate func initPullTableView() {
        self.emptyDataSetSource   = self
        self.emptyDataSetDelegate = self
    }
    
    func addRefreshView() {
        self.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.isRefreshing = true
            self.pullDelegate?.pullTableViewStartRefeshing(self)
        })
    }
    
    func addLoadMoreView() {
        self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.isLoadingMore = true
            self.pullDelegate?.pullTableViewStartLoadingMore(self)
        })
    }
}


extension HFPullTableView: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = self.titleForEmptyForm()
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                          NSAttributedStringKey.foregroundColor: UIColor(hexString: "#BCBCBC")]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    
}


extension HFPullTableView: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
