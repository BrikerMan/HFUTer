//
//  HFInfoPlanInfoCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/6.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoPlanInfoCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var classCodeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(_ model: HFInfoPlanInfoModel) {
        titleLabel.text     = model.name
        codeLabel.text      = "课程代码：\(model.code)"
        classCodeLabel.text = "教学班：\(model.classCode)"
        volumeLabel.text    = "班级容量：\(model.volume)"
        teacherLabel.text   = "开课教师：\(model.teacher)"
        remarksLabel.text   = "\(model.remarks)"
    }

}
