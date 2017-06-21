//
//  HFMineCommentsVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/6/21.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell_Bell

class HFMineCommentsVC: HFBaseViewController, XibBasedController {
    
    @IBOutlet weak var tableView: HFPullTableView!
    
    var models: [HFMineCommentModel] = []
    
    var loadingView: HFLoadingView?
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "我的评论"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(HFMineCommentsTableViewCell.self)
        
        loadingView = HFLoadingView()
        loadingView?.add(to: self.view)
        loadingView?.show()
        page = 0
        loadData() { (models) in
            self.models = models
            runOnMainThread {
                self.tableView.reloadData()
                self.loadingView?.hide()
            }
        }
    }
    
    func loadData( completion: @escaping (_ models: [HFMineCommentModel])->Void) {
        HFAPIRequest.build(api: "api/confession/myComments", method: .POST, param: ["pageIndex": page])
            .response { (json, error) in
                var models: [HFMineCommentModel] = []
                if let error = error {
                    Hud.showError(error.decs())
                } else {
                    for j in json.arrayValue {
                        models.append(HFMineCommentModel(json: j))
                    }
                }
                completion(models)
                //                print(json)
        }
    }
}


extension HFMineCommentsVC: HFPullTableViewPullDelegate {
    func pullTableViewStartRefeshing(_ tableView: HFPullTableView) {
        page = 0
        loadData() { (models) in
            self.models = models
            runOnMainThread {
                self.tableView.reloadData()
                self.tableView.endRefresh()
                self.loadingView?.hide()
            }
        }
    }
    
    func pullTableViewStartLoadingMore(_ tableView: HFPullTableView) {
        page += 1
        loadData() { (models) in
            self.models = models
            runOnMainThread {
                self.tableView.reloadData()
                if models.isEmpty {
                    self.tableView.endLoadMoreWithoutWithNoMoreData()
                } else {
                    self.tableView.endLoadMore()
                }
            }
        }
    }
}



extension HFMineCommentsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HFMineCommentsTableViewCell
        cell.blind(model: models[indexPath.row])
        return cell
    }
}

extension HFMineCommentsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: HFMineCommentsTableViewCell.reuseIdentifier,
                                          cacheBy: indexPath,
                                          configuration: { (cell) in
                                            if let cell = cell as? HFMineCommentsTableViewCell {
                                                cell.blind(model: self.models[indexPath.row])
                                            }
        })
    }
}
