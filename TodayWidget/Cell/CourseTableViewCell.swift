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
        if #available(iOSApplicationExtension 10.0, *) { } else {
            titleLabel.textColor  = UIColor.white
            detailLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        }
    }
    
    func blind(_ model:HFCourceViewModel) {
        lineView.backgroundColor = ColorManager.shared.getColor(with: model.color)
        titleLabel.text = model.name
        var hour = ""
        if model.duration == 1 {
            hour = "\(model.start + 1) 节"
        } else {
            hour = "\(model.start + 1) - \(model.start + model.duration) 节"
        }
        
        detailLabel.text = hour + "  " + model.place
    }

}
