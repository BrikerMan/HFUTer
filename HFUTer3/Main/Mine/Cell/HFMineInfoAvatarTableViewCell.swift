//
//  HFMineInfoAvatarTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineInfoAvatarTableViewCell: UITableViewCell {

    static let height: CGFloat = 80
    static let identifier = "avatarCell"
    
    @IBOutlet weak var avatarImageView: HFImageView!
    
    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeightConstraint.constant = 0.5
        avatarImageView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
