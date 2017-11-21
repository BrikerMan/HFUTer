//
//  HFInfoBookListVC.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/4/11.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoBookListVC: HFBaseViewController{
    
    // Outlets
    @IBOutlet weak var tableView: HFPullTableView!
    
    // Data
    fileprivate var bookModelList:[HFInfoBookModel] = []
    
    // View
    var loadingView:HFLoadingView?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initData()
        tableView.emptyDataTitle = "暂无借阅"
        
         AnalyseManager.QueryBook.record()
    }
    
    func setupUI(){
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func initData(){
        loadBookListFromServer()
    }
    
    func loadBookListFromServer(){
        loadingView = HFLoadingView()
        view.addSubview(loadingView!)
        loadingView?.snp.makeConstraints({ (make) in make.edges.equalTo(self.view).inset(UIEdgeInsets(top:NavbarHeight,left:0,bottom:0,right:0)) })
        loadingView?.show()
        
        let getBookListRequest = HFInfoGetBookListRequest()
        getBookListRequest.callback = self
        getBookListRequest.loadData()
    }
}

// MARKL - HFBaseAPIManagerCallBack
extension HFInfoBookListVC:HFBaseAPIManagerCallBack{
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        bookModelList = HFInfoGetBookListRequest.handleData(manager.resultDic)
//        print(bookModelList.count)
        tableView.reloadData()
        loadingView?.hide()
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}

extension HFInfoBookListVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HFInfoBookListTableCell.identifer, for: indexPath) as! HFInfoBookListTableCell
        cell.selectionStyle = .none
        let isLast:Bool = bookModelList.count == indexPath.row + 1
        cell.setupCellWithStruct(bookModelList[indexPath.row], isLast: isLast)
        return cell
    }
}
