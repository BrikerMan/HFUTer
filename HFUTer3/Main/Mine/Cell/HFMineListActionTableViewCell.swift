//
//  HFMineListActionTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineListActionTableViewCell: UITableViewCell {

    static let height:CGFloat = 44
    static let identifer = "actionCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeightConstraint.constant = 0.5
        titleLabel.textColor = HFTheme.DarkTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
