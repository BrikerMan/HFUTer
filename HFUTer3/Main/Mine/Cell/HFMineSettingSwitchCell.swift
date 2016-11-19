//
//  HFMineSettingSwitchCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFMineSettingSwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchController: UISwitch!
    
    var valueChangedBlock:((_ value:Bool)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchValueChanged(_ sender: AnyObject) {
        valueChangedBlock?(switchController.isOn)
    }
}
