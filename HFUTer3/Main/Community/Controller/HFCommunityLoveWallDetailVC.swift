//
//  HFCommunityLoveWallDetailVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFCommunityLoveWallDetailVC: HFBaseViewController, XibBasedController {
    
    @IBOutlet weak var tableView: HFPullTableView!
    
    var mainModel: HFComLoveWallListModel!
    var commentReqeust: HFGetComLoveWallCommentRequest!
    
    @IBOutlet weak var likeImageView: UIImageView!
    var commentList: [HFComLoveWallCommentModel] = []
    
    var loadingView: HFLoadingView = HFLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
        navTitle = "表白详情"
    }
    
    func loadDetail() {
        HFBaseRequest.fire("/api/confession/detail" ,
                           params:[:] ,
                           succesBlock: { (reqeust, result) in
                            
        }) { (request, error) in
            
        }
    }
    
    @objc fileprivate func loadData() {
        loadingView.show()
        commentReqeust = HFGetComLoveWallCommentRequest()
        commentReqeust.callback = self
        commentReqeust.fire(mainModel.id)
        updateLikeView()
        tableView.endLoadMore()
    }
    
    fileprivate func updateLikeView() {
        let image = mainModel.favorite ? "fm_community_love_wall_like_fill" : "fm_community_love_wall_like"
        likeImageView.image = UIImage(named: image)
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
        if mainModel.favorite {
            return
        }
        hud.showLoading("正在处理")
        HFBaseRequest.fire("/api/confession/favorite",
                           method: HFBaseAPIRequestMethod.POST,
                           params: ["id":mainModel.id],
                           succesBlock: { (request, resultDic) in
                            self.mainModel.favorite = true
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
        let conferm = UIAlertAction(title: "", style: .destructive) { _ in
            HFBaseRequest.fire(api: "/api/confession/deleteComment",
                               method: .POST,
                               params: ["id":model.id],
                               response: { (json, error) in
                                if let error = error {
                                    HFToast.showError(error)
                                } else {
                                    self.commentList.remove(at: index)
                                    self.mainModel.commentCount -= 1
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
}

extension HFCommunityLoveWallDetailVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
    
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        let result =  HFGetComLoveWallCommentRequest.handleData(manager.resultDic)
        if commentReqeust.page == 0 {
            commentList.removeAll()
            commentList = result
        } else {
            commentList += result
            if result.isEmpty {
                tableView.endLoadMoreWithoutWithNoMoreData()
            } else {
                tableView.endLoadMore()
            }
        }
        
        tableView.reloadData()
        self.loadingView.hide()
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
        commentReqeust.loadNextPage()
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
            cell.setupWithModel(mainModel, index: 0,isDetail: true)
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
            return HFCommunityLoveWallListCell.height(model: mainModel, isDetail: true)
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
            label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
            
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
