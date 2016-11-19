//
//  HFMineDonateCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import StoreKit

protocol HFMineDonateCellDelegate:class {
    func onPressBuyButton(_ product:SKProduct)
}

class HFMineDonateCell: UITableViewCell {
    
    weak var delegate: HFMineDonateCellDelegate?
    
    var product:SKProduct!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBAction func onPlayButtonPressed(_ sender: AnyObject) {
        delegate?.onPressBuyButton(self.product)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buyButton.layer.cornerRadius = 30/2
        titleLabel.textColor = HFTheme.TintColor
        buyButton.setTitleColor(HFTheme.TintColor, for: UIControlState())
        buyButton.layer.borderColor  = HFTheme.TintColor.cgColor
        buyButton.layer.borderWidth  = 0.5
    }
    
    func setup(_ model:SKProduct) {
        self.product = model
        titleLabel.text  = model.localizedTitle
        detailLabel.text = model.localizedDescription
        buyButton.setTitle("￥\(model.price)", for: UIControlState())
    }
    
}
