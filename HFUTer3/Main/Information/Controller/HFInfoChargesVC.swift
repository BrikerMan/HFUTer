//
//  HFInfoChargesVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoChargesVC: HFBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var termList: [HFInfoChargeTermModel] = []
    fileprivate var summary = ""
    
    fileprivate var loadingView: HFLoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        inidData()
        AnalyseManager.QueryCharges.record()
    }
    
    fileprivate func initUI() {
        loadingView = HFLoadingView()
        self.view.addSubview(loadingView!)
        
        loadingView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        })
    }
    
    fileprivate func inidData() {
        loadingView?.show()
        let getChargesRequest = HFInfoGetChargesRequest()
        getChargesRequest.callback = self
        getChargesRequest.loadData()
    }
    
}


extension HFInfoChargesVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        
        let result = HFInfoGetChargesRequest.handleData(manager.resultDic)
        termList = result.termList
        summary  = result.summary
        tableView.reloadData()
        loadingView?.hide()
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}

extension HFInfoChargesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return termList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termList[section].courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoChargesListCell", for: indexPath) as! HFInfoChargesListCell
        let model = termList[indexPath.section].courses[indexPath.row]
        cell.setupWithModel(model)
        return cell
    }
}

extension HFInfoChargesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HFInfoGradesChargeTableHeaderView()
        view.setupWithModel(termList[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
}
