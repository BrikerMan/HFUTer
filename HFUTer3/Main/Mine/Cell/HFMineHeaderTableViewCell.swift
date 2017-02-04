//
//  HFMineHeaderTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineHeaderTableViewCell: UITableViewCell {

    static let height:CGFloat = 205
    static let identifer = "headerCell"
    
    @IBOutlet weak var offscreenBackView: UIView!
    @IBOutlet weak var avatarView: HFImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var collegeNameLabel: UILabel!
    @IBOutlet weak var majorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.cornerRadius = 30
        
        backgroundColor = HFTheme.TintColor
        offscreenBackView.backgroundColor = HFTheme.TintColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColor), name: .tintColorUpdated, object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tintColorUpdated, object: nil)
    }
    
    func updateColor() {
        backgroundColor                   = HFTheme.TintColor
        offscreenBackView.backgroundColor = HFTheme.TintColor
    }
    
    
    func setupWithModel(_ model: HFUserModel) {
        backgroundColor                   = HFTheme.TintColor
        offscreenBackView.backgroundColor = HFTheme.TintColor
        
        nickNameLabel.text      = model.name
        collegeNameLabel.text   = model.college
        majorNameLabel.text     = model.major
        
        avatarView.loadAvatar(avatar: model.image)
    }

}
