//
//  HFHomeScheduleSelectWeekViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/21.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFHomeScheduleSelectWeekViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var isCurrentWeek = false {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor        = self.isCurrentWeek ? HFTheme.TintColor : HFTheme.WhiteBackColor
                self.titleLabel.textColor   = self.isCurrentWeek ? HFTheme.WhiteBackColor : HFTheme.DarkTextColor
            }) 
        }
    }
    
    var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = HFTheme.WhiteBackColor
        titleLabel.textColor = HFTheme.DarkTextColor
    }
    
    func setupTitle(_ title:String, withIndex index:Int) {
        titleLabel.text = title
        self.index = index
    }
    
}
