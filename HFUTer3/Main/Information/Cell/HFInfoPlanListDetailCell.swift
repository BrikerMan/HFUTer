//
//  HFInfoPlanListDetailCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/6.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoPlanListDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var cridetLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(_ model:HFInfoPlanListDetailModel) {
        titleLabel.text     = model.name
        majorLabel.text     = "开办单位：\(model.college)"
        codeLabel.text      = "课程代码：\(model.code)"
        cridetLabel.text    = "\(model.credit)"
        timeLabel.text      = "\(model.hours)"
    }

}
