//
//  HFInfoGradesStaticListCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/25.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoGradesStaticListCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cridetsLabel: UILabel!
    @IBOutlet weak var selectionCridetsLabel: UILabel!
    @IBOutlet weak var avarageGradeLabel: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    
    
    func setupWithModel(_ model: HFInfoGradesGPAModel) {
        nameLabel.text              = model.term
        cridetsLabel.text           = "：\(model.cridets + model.selectionCridets)"
        selectionCridetsLabel.text  = "：\(model.selectionCridets)"
        avarageGradeLabel.text      = "：\(model.avarage)"
        gpaLabel.text               = "：\(model.gpa)"
    }
    
}
