//
//  HFInfoGradesStaticVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoGradesStaticVC: HFBaseViewController {
    
    var termsModels: [HFTermModel] = []
    fileprivate var GPAModels  : [HFInfoGradesGPAModel] = []
    
    var shouldShowCalculate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    fileprivate func initUI() {
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func initData() {
        if shouldShowCalculate {
            if let term = HFTermModel.readModels() {
                termsModels = term
            }
        }
        
        let calculator = HFInfoGradesCalculator()
        GPAModels = calculator.calculateGPA(termsModels)
    }
    
}


extension HFInfoGradesStaticVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if shouldShowCalculate {
            return 3
        }
        return 2
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
        return 1
    } else if section == 1 && shouldShowCalculate {
        return 1
    } else {
        return GPAModels.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoGradesStaticInfoCell", for: indexPath)
        return cell
    } else if indexPath.section == 1 && shouldShowCalculate {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoGradesStaticActionCell", for: indexPath)
        return cell
    } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoGradesStaticListCell", for: indexPath) as! HFInfoGradesStaticListCell
        cell.setupWithModel(GPAModels[indexPath.row])
        return cell
    }
}
}

extension HFInfoGradesStaticVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: HFInfoSegue.PushGradesCalculatorVC.rawValue, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 81
        } else if indexPath.section == 1 && shouldShowCalculate {
            return 44
        } else {
            return 111
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
