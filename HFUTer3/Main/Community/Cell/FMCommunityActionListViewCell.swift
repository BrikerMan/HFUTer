//
//  FMCommunityActionListViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class FMCommunityActionListViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = 20
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
