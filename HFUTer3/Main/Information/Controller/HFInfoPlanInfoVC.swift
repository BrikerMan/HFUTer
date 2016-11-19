//
//  HFInfoPlanInfoVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/6.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoPlanInfoModel: HFBaseModel {
    /// 课程名称
    var name        = ""
    /// 课程代码
    var code        = ""
    /// 教学班
    var classCode   = ""
    /// 班级容量
    var volume      = ""
    /// 开课教师
    var teacher     = ""
    /// 备注
    var remarks     = ""
}


class HFInfoPlanInfoVC: HFBaseViewController {
    
    @IBOutlet weak var tableView: HFPullTableView!
    
    var term: String!
    var code: String!
    
    var modelList:[HFInfoPlanInfoModel] = []
    
    let loadingView = HFLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        navTitle = "课程详情"
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        loadingView.show()
        loadData()
        
        AnalyseManager.QueryPlan.record()
    }
    
    fileprivate func loadData() {
        let param: HFRequestParam = [
            "term": term as AnyObject,
            "code": code as AnyObject
        ]
        
        let api = "/api/user/query/planDetail"
        
        HFBaseRequest.fire(api, method: HFBaseAPIRequestMethod.POST, params: param, succesBlock: { (request, resultDic) in
            if let list = resultDic["data"] as? [AnyObject] {
                for item in list {
                    if let model = HFInfoPlanInfoModel.yy_model(withJSON: item) {
                        self.modelList.append(model)
                    }
                }
            }
            self.loadingView.hide()
            self.tableView.reloadData()
        }) { (request, error) in
            self.loadingView.hide()
            hud.showError(error)
        }
    }
}

extension HFInfoPlanInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planInfoCell") as! HFInfoPlanInfoCell
        cell.setup(modelList[indexPath.row])
        return cell
    }
}

extension HFInfoPlanInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "planInfoCell", cacheBy: indexPath, configuration: { (cell) in
            let cell = cell as! HFInfoPlanInfoCell
            cell.setup(self.modelList[indexPath.row])
        })
    }
}
