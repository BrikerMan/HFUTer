//
//  HFInfoEmptyClassroomListVC.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
//import UITableView_FDTemplateLayoutCell

class HFInfoEmptyClassroomListVC: HFBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var loadingView:HFLoadingView?
    var model:HFInfoEmptyClassroomModel?
    
    //教学楼
    var teachingBuildingIndex = 0
    //层
    var floorIndex = 0
    //教学周
    var teachingWeekIndex = 0
    //周几
    var weekIndex = 0
    //第几节课
    var sectionIndex = 0
    
    let week = ["周一","周二","周三","周四","周五","周六","周日"]
    let classNum = ["第一节课","第二节课","第三节课","第四节课","第五节课","第六节课","第七节课","第八节课","第九节课","第十节课","第十一节课"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        
        AnalyseManager.QueryEmptyClassroom.record()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let indexPath = sender as? IndexPath {
            let vc = segue.destination as! HFInfoListPickerVC
            
            switch indexPath.row {
            case 0:
                vc.title = "选择教学楼"
                vc.setItems(model!.buildings, selectedIndex: teachingBuildingIndex, withCallBackBlock: { (index) in
                    self.teachingBuildingIndex = index
                    self.tableView.reloadData()
                })
            case 1:
                vc.title = "选择楼层"
                vc.setItems(model!.floors, selectedIndex: floorIndex, withCallBackBlock: { (index) in
                    self.floorIndex = index
                    self.tableView.reloadData()
                })
            case 2:
                vc.title = "选择教学周"
                vc.setItems(model!.teachingWeeks, selectedIndex: teachingWeekIndex, withCallBackBlock: { (index) in
                    self.teachingWeekIndex = index
                    self.tableView.reloadData()
                })
            case 3:
                vc.title = "选择周几"
                vc.setItems(week, selectedIndex: weekIndex, withCallBackBlock: { (index) in
                    self.weekIndex = index
                    self.tableView.reloadData()
                })
            case 4:
                vc.title = "选择第几节课"
                vc.setItems(classNum, selectedIndex: sectionIndex, withCallBackBlock: { (index) in
                    self.sectionIndex = index
                    self.tableView.reloadData()
                })
            default:
                print(indexPath.row)
            }
        }
    }
    
    func initUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        loadingView = HFLoadingView()
        self.view.addSubview(loadingView!)
        loadingView?.snp.makeConstraints({(make) in make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavbarHeight, 0, 0, 0))})
        loadingView?.show()
    }
    
    func initData(){
        let request = HFInfoGetEmptyClassroomsListRequest()
        request.callback = self
        request.loadData()
    }
}

extension HFInfoEmptyClassroomListVC:HFBaseAPIManagerCallBack{
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        if let model = HFInfoGetEmptyClassroomsListRequest.handleData(manager.resultDic){
            self.model = model
            tableView.reloadData()
        }
        
        if let result = HFInfoGetEmptyClassroomsResultRequest.handleData(manager.resultDic){
            let alert: UIAlertController = UIAlertController(title:"查询结果", message:result,
                                                             preferredStyle:UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "确定", style: .default, handler:{
                (alerts: UIAlertAction!) -> Void in
            })
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        loadingView?.hide()
    }
    
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
}

extension HFInfoEmptyClassroomListVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoEmptyClassroomInfoTableViewCell", for: indexPath) as! HFInfoPlanInfoTableViewCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "教学楼"
                cell.infoLabel.text = model?.buildings[teachingBuildingIndex]
            case 1:
                cell.titleLabel.text = "层"
                cell.infoLabel.text = model?.floors[floorIndex]
            case 2:
                cell.titleLabel.text = "教学周"
                cell.infoLabel.text = model?.teachingWeeks[teachingWeekIndex]
            case 3:
                cell.titleLabel.text = "周几"
                cell.infoLabel.text = week[weekIndex]
            case 4:
                cell.titleLabel.text = "第几节课"
                cell.infoLabel.text = classNum[sectionIndex]
                cell.isLast = true
            default:
                return UITableViewCell()
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoEmptyClassroomInfoTableViewCell", for: indexPath) as! HFInfoPlanInfoTableViewCell
            cell.titleLabel.text = "查看空教室"
            cell.infoLabel.text = ""
            cell.isLast = true
            return cell
        }
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
////        return tableView.fd_heightForCellWithIdentifier("HFInfoEmptyClassroomInfoTableViewCell", cacheByIndexPath:indexPath,configuration:{(cell) in if let cell = cell as? HFInfoPlanInfoTableViewCell {
////        
////                }
////            })
//    }
}

extension HFInfoEmptyClassroomListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0:
            if let _ = model {
                performSegue(withIdentifier: "HFInfoPushEmptyClassroomInfoChoose", sender: indexPath)
            }
        default:
            let request = HFInfoGetEmptyClassroomsResultRequest()
            request.callback = self
            request.startQuery(withteachingBuilding: (model?.buildingCodes[teachingBuildingIndex])!, floor: (model?.floorCodes[floorIndex])!, teachingWeek: (model?.teachingWeeks[teachingWeekIndex])!, week: "\(weekIndex + 1)", section: "\(sectionIndex + 1)")
            loadingView?.show()
        }
    }
    
    
}

