//
//  FMCommunityHomeListView.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/4/18.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell_Bell
import DZNEmptyDataSet

enum HFCommunityStyle {
    case lostFind
    case loveWall
}

protocol HFCommunityHomeListViewDelegate: class {
    func listViewTableViewStartRefeshing(_ listView: HFCommunityHomeListView)
    func listViewTableViewStartLoadingMore(_ listView: HFCommunityHomeListView)
    func listViewDidSelectedAtIndex(_ listView: HFCommunityHomeListView, index: Int)
    func listView(_ listView: HFCommunityHomeListView, didChooseOnLikeButton index: Int)
    func listView(_ listView: HFCommunityHomeListView, didChooseReplyButton index: Int)
}

class HFCommunityHomeListView: HFXibView {
    
    weak var delegate: HFCommunityHomeListViewDelegate?
    
    @IBOutlet weak var tableView: HFPullTableView!
    
    var style = HFCommunityStyle.lostFind {
        didSet {
            tableView.emptyDataTitle = style == HFCommunityStyle.lostFind ? "未发布失物招领" : "未发布表白墙"
        }
    }
    
    var lostModels:[HFComLostFoundModel]    = []
    var loveModels:[HFComLoveWallListModel] = []
    
    var isAllowDelete = false
    
    override func initFromXib() {
        super.initFromXib()
        tableView.registerReusableCell(FMCommunityLostAndFindCell.self)
        tableView.registerReusableCell(FMCommunityLoveWellCell.self)
        tableView.addLoadMoreView()
        tableView.backgroundColor = HFTheme.BlackAreaColor
        tableView.pullDelegate = self
        tableView.addRefreshView()
        tableView.beginRefresh()
    }
    
    func setupWithLostModel(_ models:[HFComLostFoundModel]) {
        self.style = HFCommunityStyle.lostFind
        self.lostModels += models
        tableView.endRefresh()
        tableView.endLoadMore()
        self.tableView.reloadData()
    }
    
    func setupWithLoveModel(_ models:[HFComLoveWallListModel]) {
        self.style = HFCommunityStyle.loveWall
        self.loveModels +=  models
        tableView.endRefresh()
        tableView.endLoadMore()
        self.tableView.reloadData()
    }
    
    func deleteRow(_ index: IndexPath) {
        
        var param: HFRequestParam = [:]
        
        var url = ""
        
        if style == .lostFind {
            url = "/api/lostFound/delete"
            param["id"] = lostModels[index.row].id as AnyObject?
            
            AnalyseManager.DeletePostLost.record()
        } else {
            url = "/api/confession/delete"
            param["id"] = loveModels[index.row].id as AnyObject?
            
            AnalyseManager.DeletePostLove.record()
        }
        
        hud.showLoading("正在删除")
        HFBaseRequest.fire(url, method: HFBaseAPIRequestMethod.POST, params: param, succesBlock: { (request, resultDic) in
            hud.showMassage("删除成功")
            if self.style == .lostFind {
                self.lostModels.remove(at: index.row)
            } else {
                self.loveModels.remove(at: index.row)
            }
            self.tableView.deleteRows(at: [index], with: UITableViewRowAnimation.automatic)
        }) { (request, error) in
            hud.showError(error)
        }
        
        
    }
}

extension HFCommunityHomeListView:FMCommunityLoveWellCellDelegate {
    func cellDidPressOnLike(_ index: Int) {
        delegate?.listView(self, didChooseOnLikeButton: index)
    }
}

extension HFCommunityHomeListView: FMCommunityLostAndFindCellDelegate {
    func lostListDidPresContactButton(_ model: HFComLostFoundModel, atIndex: Int) {
        delegate?.listView(self, didChooseReplyButton: atIndex)
    }
}

extension HFCommunityHomeListView: HFPullTableViewPullDelegate {
    func pullTableViewStartRefeshing(_ tableView: HFPullTableView) {
        delegate?.listViewTableViewStartRefeshing(self)
    }
    
    func pullTableViewStartLoadingMore(_ tableView: HFPullTableView) {
        delegate?.listViewTableViewStartLoadingMore(self)
    }
}

extension HFCommunityHomeListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if style == HFCommunityStyle.lostFind {
            return lostModels.count
        } else {
            return loveModels.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if style == HFCommunityStyle.lostFind {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as FMCommunityLostAndFindCell
            cell.delegate = self
            cell.setupModel(lostModels[indexPath.row], index: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as FMCommunityLoveWellCell
            cell.delegate = self
            cell.setupWithModel(loveModels[indexPath.row], index: indexPath.row)
            return cell
        }
    }
}

extension HFCommunityHomeListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isAllowDelete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.deleteRow(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.listViewDidSelectedAtIndex(self, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if style == HFCommunityStyle.lostFind {
            return tableView.fd_heightForCell(withIdentifier: "FMCommunityLostAndFindCell", cacheBy: indexPath, configuration: { (cell) in
                if let cell = cell as? FMCommunityLostAndFindCell {
                    cell.setupModel(self.lostModels[indexPath.row], index: indexPath)
                }
            })
        } else {
            return tableView.fd_heightForCell(withIdentifier: "FMCommunityLoveWellCell", cacheBy: indexPath, configuration: { (cell) in
                if let cell = cell as? FMCommunityLoveWellCell {
                    cell.setupWithModel(self.loveModels[indexPath.row],index: indexPath.row)
                }
            })
        }
    }
}
