//
//  HFInfoAcademicClassDetailVC.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/22.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import YYModel
import UIKit

class HFInfoAcademicClassDetailVC: HFBaseViewController {
    
    // 外部传入参数
    var model:HFAcademicClassListModel?
    var termCode = ""
    
    @IBOutlet weak var tableView: UITableView!

    fileprivate var modelList:[HFAcademicClassDetailModel] = []
    
    fileprivate var loadingView: HFLoadingView?
    
    // MARK: - Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initData()
        AnalyseManager.QueryAcademicClassDetail.record()
    }
    
    // MARK: - Request
    fileprivate func loadAcademicClassDetailFromServer(){
        loadingView = HFLoadingView()
        view.addSubview(loadingView!)
        loadingView!.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: NavbarHeight, left: 0, bottom: 0, right: 0))
        })
        loadingView!.show()
        
        let getAcademicClassDetailRequest = HFInfoGetAcademicClassDetailRequest()
        getAcademicClassDetailRequest.callback = self
        getAcademicClassDetailRequest.startQuery(withTermcode: termCode, code: (model?.code)!, classCode: (model?.classCode)!)
    }
    
    // MARK: - Init
    fileprivate func setupUI(){
        //不让视图自适应
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func initData(){
        loadAcademicClassDetailFromServer()
    }
}

// MARK: - HFBaseAPIManagerCallBack
extension HFInfoAcademicClassDetailVC:HFBaseAPIManagerCallBack{
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        modelList = HFInfoAcademicViewModel.prepareClassDetailModels(manager.resultDic)
        tableView.reloadData()
        loadingView?.hide()
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}

extension HFInfoAcademicClassDetailVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HFInfoAcademicClassDetailTableCell.identifer, for: indexPath) as! HFInfoAcademicClassDetailTableCell
        cell.selectionStyle = .none
        let isLast:Bool = modelList.count == indexPath.row + 1
        cell.setupCellWithStruct(modelList[indexPath.row], isLast: isLast)
        return cell
    }
}
