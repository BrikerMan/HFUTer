//
//  HFMineInfoInfoTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

struct HFMineInfoInfoCellModel {
    var title: String
    var boolValue: Bool?
    var value: String
    var editable: Bool
    
    init(_ title: String, _ boolValue: Bool?, _ value: String, _ editable: Bool) {
        self.title = title
        self.boolValue = boolValue
        self.value = value
        self.editable = editable
    }
}

class HFMineInfoInfoTableViewCell: UITableViewCell {

    static let height: CGFloat = 44
    static let identifier = "infoCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var disclosureIndector: UIImageView!
    
    @IBOutlet weak var infoLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorConstrint: NSLayoutConstraint!
    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = HFTheme.DarkTextColor
        infoLabel.textColor  = HFTheme.GreyTextColor
        seperatorHeightConstraint.constant = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCellWithCellModel(_ model:HFMineInfoInfoCellModel, isLast:Bool) {
        titleLabel.text = model.title
        
        if let boolValue = model.boolValue {
            if boolValue {
                infoLabel.text = "已绑定"
            } else {
                infoLabel.text = "未绑定"
            }
        } else {
            infoLabel.text = model.value
        }
        
        if model.editable {
            disclosureIndector.isHidden = false
            infoLabelConstraint.constant = 35
        } else {
            disclosureIndector.isHidden = true
            infoLabelConstraint.constant = 15
        }
        
        if isLast {
            seperatorConstrint.constant = 0
        } else {
            seperatorConstrint.constant = 15
        }
    }

}
