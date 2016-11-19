//
//  HFInfoChargesListCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoChargesListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var classCodeLabel: UILabel!
    
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var cridetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupWithModel(_ model: HFInfoChargeCourseModel) {
        titleLabel.text     = model.name
        codeLabel.text      = "课程代码：\(model.code)"
        classCodeLabel.text = "教学班号：\(model.classCode)"
        chargeLabel.text    = model.charge
        cridetLabel.text    = model.credit
    }

}
