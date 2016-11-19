//
//  HFMinePublishLostFindCell.swift
//  HFUTer3
//
//  Created by 帅帅 on 16/5/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class HFMinePublishLostFindCell: UITableViewCell {
    
    static let identifier = "HFMinePublishLostFindCell"
    
    @IBOutlet weak var topColorView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var avatarImageView: HFImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var thingLabel: UILabel!
    @IBOutlet weak var timeSumLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var seperatorHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seperatorHeight.constant = 0.5
        avatarImageView.layer.cornerRadius = 20
    }
    
    func setupWithModel(_ model:HFComLostFoundModel) {
        if model.name.isBlank {
            titleLabel.text = "匿名"
        } else {
            titleLabel.text = model.name
        }
        avatarImageView.loadAvatar(avatar: model.image)
        
        infoLabel.text = model.content
        timeLabel.text = Utilities.getTimeStringFromTimeStamp(model.date_int)
        
        placeLabel.text = model.place
        thingLabel.text = model.thing
        timeSumLabel.text = model.time
        
        if model.type == 0 {
            topImageView.image = UIImage(named: "fm_community_lost_list_lost")
            topColorView.backgroundColor = UIColor(hexString: "8E44AD")
        } else {
            topImageView.image = UIImage(named: "fm_community_lost_list_found")
            topColorView.backgroundColor = UIColor(hexString: "FF8252")
        }
    }
    
    @IBAction func deleteClick(_ sender: AnyObject) {
        print("shanchu")
    }
    
}
