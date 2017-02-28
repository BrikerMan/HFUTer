//
//  CourceDayHeaderCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2016/10/30.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class CourceDayHeaderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperatorView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOSApplicationExtension 10.0, *) { } else {
            titleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
            seperatorView.tintColor = UIColor.white.withAlphaComponent(0.6)
            seperatorView.image = UIImage(named: "hf_widget_seperator_line")?.withRenderingMode(.alwaysTemplate)
        }

    }
    
    
}
