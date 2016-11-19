//
//  HFMineNotifTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/4.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineNotifTableViewCell: UITableViewCell, NibReusable {

    static var nib: UINib? {
        return UINib(nibName: String(describing: self.self), bundle: nil)
    }
    
    @IBOutlet weak var seperatorHieght: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    func setup(_ model:HFMineNotifModel) {
        titleLabel.text = model.title
        timeLabel.text  = Utilities.getTimeStringFromTimeStamp(Int(model.date/1000))
        infoLabel.text  = model.content
    }
    
}
