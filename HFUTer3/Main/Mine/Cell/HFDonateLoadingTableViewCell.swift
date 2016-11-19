//
//  HFDonateLoadingTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/8/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFDonateLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndector: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndector.startAnimating()
    }


}
