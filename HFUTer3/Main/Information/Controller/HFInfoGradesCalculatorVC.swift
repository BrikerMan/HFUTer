//
//  HFInfoGradesCalculatorVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoGradesCalculatorVC: HFBaseViewController {
    
    var termsModel: [HFTermModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        if let term = HFTermModel.readCalculatorModels(), term != []{
            termsModel = term
        }else if let term = HFTermModel.readModels() {
            termsModel = term
        }
    }
}


extension HFInfoGradesCalculatorVC: HFInfoGradesCalculatorCellDelegate {
    func calculateCell(_ cell: HFInfoGradesCalculatorCell, deletedModel model: HFGradesModel, atIndexPath indexPath: IndexPath) {
        
        let termIndex = indexPath.section - 2
        let scoreIndex = indexPath.row
        
        termsModel[termIndex].scoreList.remove(at: scoreIndex)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
        tableView.reloadData()
    }
    
    func calculateCell(_ cell: HFInfoGradesCalculatorCell, changedModel model: HFGradesModel, atIndexPath indexPath: IndexPath) {
        
    }
}



extension HFInfoGradesCalculatorVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return termsModel.count + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return 2
        }else {
            return termsModel[section - 2].scoreList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoGradesCalculatorInfoCell", for: indexPath)
            return cell
        } else if indexPath.section == 1 {
            var cell:UITableViewCell?
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoGradesCalculatorActionCell", for: indexPath)
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoGradesCalculatorResetActionCell", for: indexPath)
            }
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoGradesCalculatorCell", for: indexPath) as! HFInfoGradesCalculatorCell
            let model = termsModel[indexPath.section - 2].scoreList[indexPath.row]
            cell.setupWithModel(model, index: indexPath)
            cell.delegate = self
            return cell
        }
    }
}

extension HFInfoGradesCalculatorVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let sb = UIStoryboard(name: "Information", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "HFInfoGradesStaticVC")  as! HFInfoGradesStaticVC
                HFTermModel.saveCalculatorModels(termsModel)
                vc.termsModels = termsModel
                vc.shouldShowCalculate = false
                self.push(vc)
                
                AnalyseManager.SelfCheckGPS.record()
            }else {
                HFTermModel.saveCalculatorModels([])
                if let term = HFTermModel.readModels() {
                    termsModel = term
                }
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 93
        } else if indexPath.section == 1 {
            return 44
        } else {
            return 71
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 || section == 1 {
            return nil
        } else {
            return termsModel[section - 2].term
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
         return 10
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
