//
//  HFInfoRankingDetailCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/8/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoRankingDetailCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cridetsLabel: UILabel!
    @IBOutlet weak var selectionCridetsLabel: UILabel!
    @IBOutlet weak var avarageGradeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    func setup(_ model:HFRankingModel) {
        if model.term == "all_score" {
             model.term = "全部成绩"
        }
        nameLabel.text              = "\(model.term)"
        cridetsLabel.text           = ": \(model.average)"
        selectionCridetsLabel.text  = ": \(model.averageGPA)"
        avarageGradeLabel.text      = ": \(model.index)"
    }
    
}
