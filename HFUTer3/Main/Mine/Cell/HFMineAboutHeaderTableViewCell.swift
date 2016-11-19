//
//  HFMineAboutHeaderTableViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/10.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineAboutHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let infoPlist = Bundle.main.infoDictionary!
        let version = infoPlist["CFBundleShortVersionString"] as! String
        let bundle = infoPlist["CFBundleVersion"] as! String
        
        versionLabel.text = "V\(version)(\(bundle))"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
