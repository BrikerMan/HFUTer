//
//  HFCommunityLoveWallDetailVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import PromiseKit

class HFCommunityLoveWallDetailVC: HFBaseViewController, XibBasedController {
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: HFPullTableView!
    
    var mainModel: HFComLoveWallListModel!
    let viewModel  = HFCommunityDetailViewModel()
    var commentList: [HFComLoveWallCommentModel] = []
    
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    var loadingView: HFLoadingView = HFLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.model = mainModel
        initUI()
        loadData()
        navTitle = "表白详情"
    }
    
    fileprivate func loadData() {
        loadingView.show()
        
        let detail   = viewModel.loadDetail()
        let comments = viewModel.loadComments(page: 0)
        
        when(fulfilled: detail, comments)
            .then { model, comments -> Void in
                self.mainModel = model
                self.commentList = comments
                self.updateLikeView()
                runOnMainThread {
                    self.loadingView.hide()
                    self.tableView.reloadData()
                }
                
            }.catch { error in
                Hud.showError(error.hfDescription)
        }
    }
    
    func sendCommentRequest(_ param: HFRequestParam) {
        HFBaseRequest.fire("/api/confession/comment", method: HFBaseAPIRequestMethod.POST, params: param, succesBlock: { (request, resultDic) in
            hud.showMassage("发送成功")
            self.loadData()
        }) { (request, error) in
            hud.showError(error)
        }
    }
    
    @IBAction func onLikeButtonPressed(_ sender: AnyObject) {
        if mainModel.favorite.value {
            return
        }
        hud.showLoading("正在处理")
        HFBaseRequest.fire("/api/confession/favorite",
                           method: HFBaseAPIRequestMethod.POST,
                           params: ["id":mainModel.id],
                           succesBlock: { (request, resultDic) in
                            self.mainModel.favorite.value = true
                            self.mainModel.favoriteCount += 1
                            self.updateLikeView()
                            runOnMainThread {
                                self.tableView.reloadData()
                            }
                            hud.dismiss()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.LoveWallModelUpdate.rawValue), object: nil)
        }) { (request, error) in
            hud.showError(error)
        }
    }
    
    @IBAction func onCommentButtonPressed(_ sender: AnyObject) {
        let vc = HFCommonWriteVC()
        vc.publishBlock = { text,anonymous in
            let param: HFRequestParam = [
                "id": self.mainModel.id,
                "content":  text,
                "anonymous" :anonymous
            ]
            self.sendCommentRequest(param)
            AnalyseManager.CommentLoveWall.record()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func onDeletePressed(model: HFComLoveWallCommentModel, index: Int) {
        let alert = UIAlertController(title: "确定删除？", message: nil, preferredStyle: .alert)
        let conferm = UIAlertAction(title: "确定", style: .default) { _ in
            HFBaseRequest.fire(api: "/api/confession/deleteComment",
                               method: .POST,
                               params: ["id":model.id],
                               response: { (json, error) in
                                if let error = error {
                                    HFToast.showError(error)
                                } else {
                                    self.commentList.remove(at: index)
                                    self.mainModel.commentCount = self.commentList.count
                                    runOnMainThread {
                                        self.tableView.reloadData()
                                    }
                                }
            })
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in
            
        }
        alert.addAction(conferm)
        alert.addAction(cancel)
        self.presentVC(alert)
    }
    
    fileprivate func initUI() {
       topViewHeight.constant = CGFloat(NavbarHeight)
        bottomViewHeight.constant = CGFloat(TabbarHeight)
        tableView.registerReusableCell(HFCommunityLoveWallListCell.self)
        tableView.registerReusableCell(HFCommunityLoveDetailCommentCell.self)
        tableView.backgroundColor = HFTheme.BlackAreaColor
        tableView.addLoadMoreView()
        tableView.pullDelegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
    }
    
    fileprivate func updateLikeView() {
        let image = mainModel.favorite.value ? "fm_community_love_wall_like_fill" : "fm_community_love_wall_like"
        likeImageView.image = UIImage(named: image)
    }
}

extension HFCommunityLoveWallDetailVC: HFCommunityLoveDetailCommentCellDelegate {
    func commentCell(cell: HFCommunityLoveDetailCommentCell, didPessOnAction action: HFCommentActionType) {
        let model = cell.model!
        switch action {
        case .replyComment:
            let vc = HFCommonWriteVC()
            vc.at = model.name
            vc.publishBlock = { text,anonymous in
                let at:NSArray = [model.uid]
                let atString = at.yy_modelToJSONString()!
                let param: HFRequestParam = [
                    "id": self.mainModel.id,
                    "content":  text,
                    "anonymous" :anonymous,
                    "at": atString
                ]
                self.sendCommentRequest(param)
            }
            self.present(vc, animated: true, completion: nil)
            
        case .delete:
            onDeletePressed(model: model, index: cell.index)
        }
    }
}

extension HFCommunityLoveWallDetailVC: HFPullTableViewPullDelegate {
    func pullTableViewStartRefeshing(_ tableView: HFPullTableView) {
        
    }
    
    func pullTableViewStartLoadingMore(_ tableView: HFPullTableView) {
        viewModel.loadNextComments()
            .then { result -> Void in
                self.commentList += result
                if result.isEmpty {
                    self.tableView.endLoadMoreWithoutWithNoMoreData()
                } else {
                    self.tableView.endLoadMore()
                }
                if self.mainModel.commentCount < self.commentList.count {
                    self.mainModel.commentCount = self.commentList.count
                }
                runOnMainThread {
                    self.tableView.reloadData()
                }
            }.catch { error in
                Hud.showError(error.hfDescription)
        }
    }
}


extension HFCommunityLoveWallDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if commentList.isEmpty {
                return 1
            } else {
                return commentList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HFCommunityLoveWallListCell
            cell.setupWithModel(mainModel, index: 0)
            return cell
        } else {
            if commentList.isEmpty {
                let cell = UITableViewCell()
                let label = UILabel()
                label.text = "快来发表你的评论吧"
                label.font = UIFont.systemFont(ofSize: 12)
                label.textColor = HFTheme.LightTextColor
                cell.addSubview(label)
                label.snp.makeConstraints {
                    $0.centerY.equalTo(cell.snp.centerY)
                    $0.centerX.equalTo(cell.snp.centerX)
                }
                return cell
            } else {
                self.tableView.shouldStartPrefetch(at: indexPath, dataCount: commentList.count)
                let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HFCommunityLoveDetailCommentCell
                cell.delegate = self
                cell.setup(commentList[indexPath.row], index: indexPath.row)
                return cell
            }
        }
    }
}

extension HFCommunityLoveWallDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HFCommunityLoveWallListCell.height(model: mainModel)
        } else {
            if commentList.isEmpty {
                return 200
            } else {
                return HFCommunityLoveDetailCommentCell.height(model: commentList[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView()
            let container = UIView()
            view.addSubview(container)
            container.snp.makeConstraints {
                $0.edges.equalTo(view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            }
            container.backgroundColor = UIColor.white
            container.addSeperator(isTop: true)
            container.addSeperator()
            
            let label  = UILabel()
            label.text = "评论 \(mainModel.commentCount) 赞 \(mainModel.favoriteCount)"
            label.textColor = HFTheme.DarkTextColor
            
            if #available(iOS 8.2, *) {
                label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
            } else {
                label.font = UIFont.boldSystemFont(ofSize: 14)
            }
            
            container.addSubview(label)
            label.snp.makeConstraints {
                $0.centerY.equalTo(container.snp.centerY)
                $0.left.equalTo(container.snp.left).offset(10)
            }
            return view
        }
        return nil
    }
}
