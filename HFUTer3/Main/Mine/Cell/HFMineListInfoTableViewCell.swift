//
//  HFMineListInfoTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/6.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
class HFMineListInfoTableViewCell: UITableViewCell {
    
    static let height:CGFloat = 44
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorLeftConsraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeightConstraint.constant = 0.5
        titleLabel.textColor = HFTheme.DarkTextColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ title:String, isLast:Bool) {
        titleLabel.text = title
        if isLast {
            seperatorLeftConsraint.constant = 0
        } else {
            seperatorLeftConsraint.constant = 15
        }
    }
    
}
