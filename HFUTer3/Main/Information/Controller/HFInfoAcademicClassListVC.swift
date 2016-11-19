//
//  HFInfoAcademicClassListVC.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/21.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit



class HFInfoAcademicClassListVC: HFBaseViewController  {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Data
    fileprivate var termModel: HFAcademicClassTermModel?
    fileprivate var chosenAcademicClass:HFAcademicClassListModel?
    
    // View
    fileprivate var loadingView: HFLoadingView?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initData()
        AnalyseManager.QueryAcademicClass.record()
    }
    
    /**
     方法重写放在这里
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == HFInfoSegue.PushClassDetailVC.rawValue {
            let vc = segue.destination as! HFInfoAcademicClassDetailVC
            vc.model    = self.chosenAcademicClass
            vc.termCode = self.termModel!.termCode
        }
    }
    
    // MARK:- Requests
    func loadAcademicClassFromServer(){
        loadingView = HFLoadingView()
        view.addSubview(loadingView!)
        loadingView!.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0))
        })
        loadingView!.show()
        
        let getAcademicClassListRequest = HFInfoGetAcademicClassListRequest()
        getAcademicClassListRequest.callback = self
        getAcademicClassListRequest.loadData()
    }
    
    
    // MARK:- Init
    fileprivate func setupUI(){
    
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func initData(){
        loadAcademicClassFromServer()
    }
    
    
}

// MARK: - HFBaseAPIManagerCallBack
extension HFInfoAcademicClassListVC:HFBaseAPIManagerCallBack{
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        
        /**
         应该用ViewModel解析这个，然后直接返回一个ModelList
         */
        
        if let result = HFInfoAcademicViewModel.prepareTermModel(manager.resultDic) {
            termModel = result
            tableView.reloadData()
        }
        
        loadingView?.hide()
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}

// MARK: - UITableViewDelegate
extension HFInfoAcademicClassListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenAcademicClass = self.termModel?.list[indexPath.row]
        performSegue(withIdentifier: HFInfoSegue.PushClassDetailVC.rawValue, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
extension HFInfoAcademicClassListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let term = termModel {
            return term.list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HFInfoAcademicClassTableCell.identifer, for: indexPath) as! HFInfoAcademicClassTableCell
        cell.accessoryType = .none
        let isLast:Bool = termModel!.list.count == indexPath.row + 1
        cell.setupCellWithStruct(termModel!.list[indexPath.row],isLast: isLast)
        return cell
    }
}
