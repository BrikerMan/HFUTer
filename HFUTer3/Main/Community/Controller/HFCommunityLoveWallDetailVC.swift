//
//  HFCommunityLoveWallDetailVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFCommunityLoveWallDetailVC: HFBaseViewController {
    
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
    
    @objc fileprivate func loadData() {
        loadingView.show()
        commentReqeust = HFGetComLoveWallCommentRequest()
        commentReqeust.callback = self
        commentReqeust.fire(mainModel.id)
        updateLikeView()
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
        HFBaseRequest.fire("/api/confession/favorite", method: HFBaseAPIRequestMethod.POST, params: ["id":mainModel.id as AnyObject], succesBlock: { (request, resultDic) in
            self.mainModel.favorite = true
            self.mainModel.favoriteCount += 1
            self.updateLikeView()
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
                "id": self.mainModel.id as AnyObject,
                "content":  text as AnyObject,
                "anonymous" :anonymous as AnyObject
            ]
            self.sendCommentRequest(param)
            AnalyseManager.CommentLoveWall.record()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func initUI() {
        tableView.registerReusableCell(FMCommunityLoveWellCell.self)
        tableView.backgroundColor = HFTheme.BlackAreaColor
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
        commentList = result
        tableView.reloadData()
        self.loadingView.hide()
    }
}


extension HFCommunityLoveWallDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        let model = commentList[indexPath.row]
        if model.uid == 0 {
            hud.showError("不能回复匿名用户")
            return
        } else {
//            HFBaseRequest.fire("/api/confession/delete", method: HFBaseAPIRequestMethod.POST, params: ["id":model.id], succesBlock: { (request, resultDic) in
//               print(resultDic)
//            }) { (request, error) in
//                hud.showError(error)
//            }
            
            let vc = HFCommonWriteVC()
            vc.at = model.name
            vc.publishBlock = { text,anonymous in
                let at:NSArray = [model.uid]
                let atString = at.yy_modelToJSONString()!
                let param: HFRequestParam = [
                    "id": self.mainModel.id as AnyObject,
                    "content":  text as AnyObject,
                    "anonymous" :anonymous as AnyObject,
                    "at": atString as AnyObject
                ]
                self.sendCommentRequest(param)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "FMCommunityLoveWellCell", cacheBy: indexPath, configuration: { (cell) in
            if let cell = cell as? FMCommunityLoveWellCell {
                if indexPath.section == 0{
                    cell.setupWithModel(self.mainModel, index: indexPath.row)
                } else {
                    cell.setupWithCommentModel(self.commentList[indexPath.row])
                }
                cell.bottomViewHeight.constant = 0
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 5
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}

extension HFCommunityLoveWallDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as FMCommunityLoveWellCell
        if indexPath.section == 0{
            cell.setupWithModel(mainModel,index: 0)
        } else {
            cell.setupWithCommentModel(commentList[indexPath.row])
        }
        cell.bottomViewHeight.constant = 0
        return cell
    }
}
 
