//
//  HFInfoPlanListVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoPlanListVC: HFBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var loadingView: HFLoadingView?
    var model: HFInfoPlanListModel?
    
    var termNameIndex = 0
    var majorNameIndex = 0
    
    var switchController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        
        AnalyseManager.QueryPlanList.record()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == "HFInfoPushPlanDetailSegue" {
            if let vc = segue.destination as? HFInfoPlanDetailVC {
                let model = self.model!
                vc.majorCode = model.majorCode[self.majorNameIndex]
                vc.termCode  = model.termCode[self.termNameIndex]
                vc.segmentIndex   = self.switchController.selectedSegmentIndex
            }
        } else {
            if let indexPath = sender as? IndexPath {
                
                let vc = segue.destination as! HFInfoListPickerVC
                
                if indexPath.row == 1 {
                    vc.title = "选择学期"
                    vc.setItems(model!.term, selectedIndex: termNameIndex, withCallBackBlock: { (index) in
                        self.termNameIndex = index
                        self.tableView.reloadData()
                    })
                } else {
                    vc.title = "选择专业"
                    vc.setItems(model!.major, selectedIndex: majorNameIndex, withCallBackBlock: { (index) in
                        self.majorNameIndex = index
                        self.tableView.reloadData()
                    })
                }
            }
        }
        
    }
    
    
    fileprivate func initUI() {
        loadingView = HFLoadingView()
        self.view.addSubview(loadingView!)
        loadingView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavbarHeight, 0, 0, 0))
        })
        loadingView?.show()
    }
    
    fileprivate func initData() {
        let request = HFInfoGetPlansListRequst()
        request.callback = self
        request.loadData()
    }
    
}

extension HFInfoPlanListVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
    
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        if let model = HFInfoGetPlansListRequst.handleData(manager.resultDic) {
            self.model = model
            tableView.reloadData()
        }
        loadingView?.hide()
    }
}


extension HFInfoPlanListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoPlanTypeTableViewCell", for: indexPath) as! HFInfoPlanTypeTableViewCell
            self.switchController = cell.classSwitch
            return cell
        case (0,1),(0,2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoPlanInfoTableViewCell", for: indexPath) as! HFInfoPlanInfoTableViewCell
            if indexPath.row == 1 {
                cell.titleLabel.text = "学期"
                cell.infoLabel.text  = model?.term[termNameIndex]
            } else {
                cell.titleLabel.text = "专业"
                cell.infoLabel.text  = model?.major[majorNameIndex]
                cell.isLast = true
            }
            return cell
            
        case (1,0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoPlanInfoTableViewCell", for: indexPath) as! HFInfoPlanInfoTableViewCell
            cell.titleLabel.text = "查看计划"
            cell.infoLabel.text  = ""
            cell.isLast = true
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension HFInfoPlanListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (0,1),(0,2):
            if let _ = model {
                performSegue(withIdentifier: "HFInfoPushPlanInfoChoose", sender: indexPath)
            }
        case (1,0):
            if let _ = model {
                performSegue(withIdentifier: "HFInfoPushPlanDetailSegue", sender: indexPath)
            }
        default:
            print("")
        }
        
    }
}
