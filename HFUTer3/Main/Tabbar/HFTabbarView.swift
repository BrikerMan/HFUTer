//
//  HFTabbarView.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/3.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

protocol HFTabbarViewDelegate: class {
    func tabbar(_ tabbar:HFTabbarView, didSelectedIndex index: Int)
}

class HFTabbarView: HFXibView {
    
    weak var delegate: HFTabbarViewDelegate?
    
    var shouldShowBandge = false {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndex = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let tabbarItems:[(title:String, icon:String)] = [
        ("课表","fm_tabbar_calendar"),
        ("社区","fm_tabbar_community"),
        ("查询","fm_tabbar_info"),
        ("我的","fm_tabbar_mine")
    ]
    
    override func initFromXib() {
        super.initFromXib()
        collectionView.registerReusableCell(HFTabbarCollectionViewCell.self)
    }
}

extension HFTabbarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        delegate?.tabbar(self, didSelectedIndex: indexPath.row)
    }
}

extension HFTabbarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenWidth/CGFloat(tabbarItems.count), height: self.frame.height)
    }
}

extension HFTabbarView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as HFTabbarCollectionViewCell
        let item = tabbarItems[indexPath.row]
        cell.setup(item.title, icon: item.icon, selected: selectedIndex == indexPath.row)
        if indexPath.row == 3 && shouldShowBandge{
            cell.hubView.isHidden = false
        } else {
            cell.hubView.isHidden = true
        }
        return cell
    }
}
