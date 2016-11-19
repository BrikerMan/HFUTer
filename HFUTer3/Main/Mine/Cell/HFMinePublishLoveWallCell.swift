//
//  HFMinePublishVCLoveWallCell.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/5/29.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFMinePublishLoveWallCell: UITableViewCell {
    
    static let identifier = "HFMinePublishLoveWallCell"

    @IBOutlet weak var avatarView: HFImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var seperator2Height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.cornerRadius = 20
        seperator2Height.constant = 0.5
    }
    
    func setupWithModel(_ model:HFComLoveWallListModel) {
        avatarView.loadAvatar(avatar: model.image)
        if model.name.isBlank {
            nameLabel.text = "匿名"
        } else {
            nameLabel.text = model.name
        }
        
        timeLabel.text = Utilities.getTimeStringFromTimeStamp(model.date_int)
        infoLabel.text = model.content
    }
}
