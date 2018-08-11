//
//  HFInformationVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInformationVC: HFBaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let features = [
        HFInformationFonctionListModel("成绩 · 绩点"    , "fm_information_grades",   HFInfoSegue.PushGradesVC.rawValue),
        HFInformationFonctionListModel("教学班查询"  , "fm_information_classes",  HFInfoSegue.PushClassListVC.rawValue)
    ]
    
    let tableViewFeature = [
        HFTableInfoCellModel(title: "收费"    , icon: "fm_information_fee"),
        HFTableInfoCellModel(title: "计划"    , icon: "fm_information_schedule"),
        HFTableInfoCellModel(title: "校历"    , icon: "fm_information_calendar"),
        HFTableInfoCellModel(title: "空教室"  , icon: "fm_information_empty"),
        HFTableInfoCellModel(title: "图书借阅", icon: "fm_information_book", isLast: true),
        HFTableInfoCellModel(title: "排名查询" , icon: "fm_information_ranking", isLast: true),
    ]
    
    let tableViewSegues = [
        HFInfoSegue.PushChargesVC , .PushPlansVC, .PushPlansVC, .PushEmptyClassroomVC, .PushBookListVC, .PushRankingVC
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.layer.shadowColor  = UIColor.black.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        collectionView.layer.shadowOpacity = 0.2
        shouldShowBackButton = false
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerReusableCell(HFTableInfoCell.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTint), name: .tintColorUpdated, object: nil)
    }
    
    @objc func updateTint() {
        runOnMainThread {
            self.collectionView.reloadData()
        }
    }
    
    func pushToGrades() {
        self.performSegue(withIdentifier: HFInfoSegue.PushGradesVC.rawValue, sender: nil)
    }
    
    func pushToCalendar() {
        let vc = HFInfoCalendarVC(nibName: "HFInfoCalendarVC", bundle: nil)
        self.push(vc)
    }
    
}

extension HFInformationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewFeature.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HFTableInfoCell
        cell.setup(tableViewFeature[indexPath.row])
        cell.topSeperator.isHidden = indexPath.row != 0
        return cell
    }
}

extension HFInformationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let vc = HFInfoCalendarVC(nibName: "HFInfoCalendarVC", bundle: nil)
            self.push(vc)
        } else {
            self.performSegue(withIdentifier: tableViewSegues[indexPath.row].rawValue, sender: nil)
        }
    }
}


extension HFInformationVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HFInformationCollectionCell.identifier, for: indexPath) as! HFInformationCollectionCell
        cell.setupWithModel(features[indexPath.row])
        return cell
        
    }
}


extension HFInformationVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: features[indexPath.row].segue, sender: nil)
    }
}

extension HFInformationVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (ScreenWidth - 0.5)/2
        return CGSize(width: width, height: 160)
    }
}
