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
    
    fileprivate var viewModel = HFParseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        viewModel.dataType = .grades
        viewModel.controller = self
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
        viewModel.fetchGrades { (terms, error) in
            self.loadingView?.hide()
            if let error = error {
                self.showEduError(error: error)
            } else {
                self.termList = terms
                runOnMainThread {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension HFInfoGradesVC: HFPullTableViewPullDelegate {
    func pullTableViewStartRefeshing(_ tableView: HFPullTableView) {
        viewModel.refreshGrades { (terms, error) in
            if let error = error {
                self.showEduError(error: error)
            } else {
                self.termList = terms
                runOnMainThread {
                    self.tableView.reloadData()
                    self.tableView.endRefresh()
                }
            }
        }
    }
    
    func pullTableViewStartLoadingMore(_ tableView: HFPullTableView) {
        
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
