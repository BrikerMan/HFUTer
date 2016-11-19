//
//  HFInfoGradesChargeTableHeaderView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/26.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoGradesChargeTableHeaderView: HFXibView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summeryLabel: UILabel!

    func setupWithModel(_ model: HFInfoChargeTermModel) {
        titleLabel.text = model.term
        
        var charge = model.termCharge.replacingOccurrences(of: "；", with: "\n")
        charge = charge.replacingOccurrences(of: model.term, with: "")
        summeryLabel.text = charge
    }

}
