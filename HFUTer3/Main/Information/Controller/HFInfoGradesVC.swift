//
//  HFInfoGradesVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoGradesVC: HFBaseViewController {
    
    @IBOutlet weak var tableView: HFPullTableView!
    
    fileprivate var termList: [HFTermModel] = []
    
    fileprivate var loadingView: HFLoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        AnalyseManager.CheckGrades.record()
    }
    
    
    override func onNavRightButtonPressed() {
        performSegue(withIdentifier: HFInfoSegue.PushGradesStaticVC.rawValue, sender: nil)
        AnalyseManager.CheckGPA.record()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initData()
    }
    
    fileprivate func initUI() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.pullDelegate = self
        tableView.addRefreshView()
        loadingView = HFLoadingView()
        view.addSubview(loadingView!)
        loadingView!.snp.makeConstraints({ (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavbarHeight, 0, 0, 0))
        })
        navRightButton = navRightIconType.Static
    }
    
    fileprivate func initData() {
        loadingView?.show()
        if let result = HFTermModel.readModels() {
            termList = result
            tableView.reloadData()
        } else {
            loadingView?.show()
            let request = HFInfoGetScoresRequest()
            //防止首次登陆时服务器没数据，所以此处需要服务器更新数据
            request.shouldUpdate = true
            request.callback = self
            request.loadData()
        }
    }
}

extension HFInfoGradesVC: HFPullTableViewPullDelegate {
    func pullTableViewStartRefeshing(_ tableView: HFPullTableView) {
        let request = HFInfoGetScoresRequest()
        request.shouldUpdate = true
        request.callback = self
        request.loadData()
    }
    
    func pullTableViewStartLoadingMore(_ tableView: HFPullTableView) {
        
    }
}

extension HFInfoGradesVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        loadingView?.hide()
        
        // 首次获取，则从这个接口拉去，并做缓存，显示
        // 下拉刷新的话，从学校获取，然后缓存，显示
        termList = HFInfoGetScoresRequest.handleData(manager.resultDic)
        HFTermModel.saveModels(termList)
        tableView.reloadData()
        tableView.endRefresh()
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}

extension HFInfoGradesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return termList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termList[section].scoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HFInfoGradesListTableViewCell.identifier, for: indexPath) as! HFInfoGradesListTableViewCell
        let model = termList[indexPath.section].scoreList[indexPath.row]
        cell.selectionStyle = .none
        cell.setupWithModel(model)
        return cell
    }
}

extension HFInfoGradesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return termList[section].term
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = termList[indexPath.section].scoreList[indexPath.row]
        return HFInfoGradesListTableViewCell.getHeightForModel(model)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
}
