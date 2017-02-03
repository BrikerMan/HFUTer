//
//  HFMineChooseColorCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/2/3.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineChooseColorCell: UITableViewCell, NibReusable {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = 10
    }
}
