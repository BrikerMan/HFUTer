//
//  HFHomeScheduleSelectWeekView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/21.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol HFHomeScheduleSelectWeekViewDelegate :class{
    func selectWeekViewDidSelectedOnWeek(weekIndex index:Int)
}

class HFHomeScheduleSelectWeekView: HFXibView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HFHomeScheduleSelectWeekViewDelegate?
    
    var weeksNum = 25
    var numberOfCellInLine:CGFloat = 5
    var cellHeight:CGFloat = 30
    
    var selectedWeek = 0
    
    /// 选择View高度
    var height:CGFloat {
        get {
            let lines = Int((weeksNum - 1) / Int(numberOfCellInLine)) + 1
            return CGFloat(lines) * (cellHeight + 1) + 1
        }
    }
    
    override func initFromXib() {
        super.initFromXib()
        view?.backgroundColor = HFTheme.BlackAreaColor
        collectionView.backgroundColor = HFTheme.BlackAreaColor
        let cell = UINib(nibName: "HFHomeScheduleSelectWeekViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "cell")
        setupSelectedWeek(0)
    }
    
    func setupSelectedWeek(_ week:Int) {
        self.selectedWeek = week
        self.collectionView.reloadData()
    }
}

extension HFHomeScheduleSelectWeekView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWeek = indexPath.row
        for cell in collectionView.visibleCells  {
            let cell = cell as! HFHomeScheduleSelectWeekViewCell
            cell.isCurrentWeek = cell.index == selectedWeek
        }
        delegate?.selectWeekViewDidSelectedOnWeek(weekIndex: indexPath.row)
    }
}

extension HFHomeScheduleSelectWeekView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = ScreenWidth
        let cellWidth = (collectionViewWidth - numberOfCellInLine - 1)/5
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension HFHomeScheduleSelectWeekView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HFHomeScheduleSelectWeekViewCell
        if indexPath.row == 0 {
            cell.setupTitle("全部", withIndex: 0)
        } else {
            cell.setupTitle("第 \(indexPath.row) 周", withIndex: indexPath.row)
        }
        cell.isCurrentWeek = cell.index == selectedWeek
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeksNum
    }
}
