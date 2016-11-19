//
//  CourseTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/8/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.layer.cornerRadius = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func blind(_ model:HFCourseModel) {
        lineView.backgroundColor = ColorManager.shared.getColorForCourses(withName: model.name)
        titleLabel.text = model.name
        var hour = ""
        switch model.hourNum {
        case 0:
            hour = "1 - 2 节"
        case 1:
            hour = "3 - 4 节"
        case 2:
            hour = "5 - 6 节"
        case 3:
            hour = "7 - 8 节"
        case 3:
            hour = "9 - 11 节"
        default:
            break
        }
        
        detailLabel.text = hour + "  " + model.place
    }

}
