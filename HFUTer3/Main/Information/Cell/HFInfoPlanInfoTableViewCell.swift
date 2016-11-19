//
//  HFInfoPlanInfoTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoPlanInfoTableViewCell: UITableViewCell {

    var isLast = false {
        didSet {
            if isLast {
                seperatorLeftConstraint.constant = 0
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var seperatorLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorheightConstarint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       seperatorheightConstarint.constant = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
