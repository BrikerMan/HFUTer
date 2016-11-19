//
//  HFTableInfoCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/10.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

struct HFTableInfoCellModel {
    var icon  : String?
    var title : String
    var isLast: Bool
    
    init(title: String, icon:String? , isLast:Bool = false ) {
        self.icon   = icon
        self.title  = title
        self.isLast = isLast
    }
}



class HFTableInfoCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var topSeperator: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var topSeperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var seperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var seperatorRight: NSLayoutConstraint!
    
    @IBOutlet weak var titleRight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topSeperator.isHidden = false
        seperatorHeight.constant = SeperatorHeight
        topSeperatorHeight.constant = SeperatorHeight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(_ model:HFTableInfoCellModel) {
        if let icon = model.icon {
            iconImageView.isHidden    = false
            iconImageView.image     = UIImage(named: icon)
            titleRight.constant     = 50
            seperatorRight.constant = model.isLast ? 0 : 50
        } else {
            iconImageView.isHidden    = true
            titleRight.constant     = 15
            seperatorRight.constant = model.isLast ? 0 : 15
        }
        
        titleLabel.text = model.title
    }
    
}
