//
//  HFMineListTableViewCell.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

struct HFMineListCellInfo {
    var title:String
    var icon:String
    var segueIdentifer:String
    
    
    init(_ title:String,_ icon:String,_ segueIdentifer:String) {
        self.title = title
        self.icon  = icon
        self.segueIdentifer = segueIdentifer
    }
}

class HFMineListTableViewCell: UITableViewCell {
    
    static let height:CGFloat = 44
    static let identifer = "listCell"
    
    @IBOutlet weak var iconImageView: HFPlaceholdImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorLeftConsraint: NSLayoutConstraint!
    @IBOutlet weak var hubView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 3
        iconImageView.clipsToBounds = true
        seperatorHeightConstraint.constant = 0.5
        titleLabel.textColor = HFTheme.DarkTextColor
        hubView.layer.cornerRadius = 4
        hubView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellWithStruct(_ model:HFMineListCellInfo, isLast:Bool) {
        titleLabel.text = model.title
        iconImageView.image = UIImage(named: model.icon)
        if isLast {
            seperatorLeftConsraint.constant = 0
        } else {
            seperatorLeftConsraint.constant = 50
        }
    }
    
}
