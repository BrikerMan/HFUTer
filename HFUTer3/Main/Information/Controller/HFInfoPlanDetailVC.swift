//
//  HFInfoPlanDetailVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell_Bell

class HFInfoPlanDetailVC: HFBaseViewController {
    
    var termCode        = ""
    var majorCode       = ""
    var segmentIndex    = 0
    
    var modelList: [HFInfoPlanListDetailModel] = []
    
    @IBOutlet weak var tableView: HFPullTableView!
    
    fileprivate var loadingView = HFLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "计划列表"
        initUI()
        loadData()
        
         AnalyseManager.QueryPlanDetail.record()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? HFInfoPlanInfoVC, let indexPath = sender as? IndexPath {
            vc.code = modelList[indexPath.row].code
            vc.term = self.termCode
        }
    }
    
    fileprivate func initUI() {
        tableView.tableFooterView = UIView()
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
    }
    
    fileprivate func loadData() {
        loadingView.show()
        let request = HFInfoGetPlanDetailRequest()
        request.callback = self
        request.fire(segmentIndex, termCode, majorCode)
    }
}

extension HFInfoPlanDetailVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planDetailCell") as! HFInfoPlanListDetailCell
        cell.setup(modelList[indexPath.row])
        return cell
    }
}

extension HFInfoPlanDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "HFPushInfoPlanInfoSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "planDetailCell", cacheBy: indexPath, configuration: { (cell) in
            let cell = cell as! HFInfoPlanListDetailCell
            cell.setup(self.modelList[indexPath.row])
        })
    }
}

extension HFInfoPlanDetailVC : HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        let result = HFInfoGetPlanDetailRequest.handleData(manager.resultDic)
        self.modelList = result
        tableView.reloadData()
        loadingView.hide()
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        
    }
}
