//
//  HFMineMessageTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/4.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineMessageTableViewCell: UITableViewCell, NibReusable {
    
    static var nib: UINib? {
        return UINib(nibName: String(describing: self.self), bundle: nil)
    }
    
    @IBOutlet weak var avatarView: HFImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.cornerRadius = 20
    }
    
    func setup(_ model:HFMineMessageModel) {
        avatarView.loadAvatar(avatar: model.sImage)
        timeLabel.text  = Utilities.getTimeStringFromTimeStamp(model.date_int)
        if model.name.isBlank {
            nickNameLabel.text = "匿名"
        } else {
            nickNameLabel.text = model.name
        }
        infoLabel.text = model.message
    }
    
}
