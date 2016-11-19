//
//  HFInfoPlanTypeTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoPlanTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var seperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var classSwitch: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeight.constant = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
