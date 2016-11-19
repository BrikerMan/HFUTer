//
//  HFChooseTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFChooseTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var seperatorLeftContraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorHeightContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorHeightContraint.constant = 0.5
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupCell(withTitle title:String, isLast:Bool) {
        titleLabel.text = title
        if isLast {
            seperatorLeftContraint.constant = 0
        } else {
            seperatorLeftContraint.constant = 15
        }
    }
    
}
