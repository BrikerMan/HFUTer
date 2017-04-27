//
//  HFScheduleViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/26.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFScheduleViewCell: HFXibView {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    var models: [HFCourceViewModel] = []
    
    
    override func initFromXib() {
        super.initFromXib()
        backView.layer.cornerRadius = 2
    }
    
    func setup(model: HFCourceViewModel) {
        models = []
        models.append(model)
        updateUI()
    }
    
    func add(model: HFCourceViewModel) {
        models.append(model)
        updateUI()
    }
    
    func updateUI() {
        nameLabel.text = models.map { $0.name }.joined(separator: " / ")
        placeLabel.text = models.map { $0.place }.joined(separator: " / ")
        if let colorName = models.first?.cources.first?.colorName {
            backView.backgroundColor = HFTheme.getColor(with: colorName)
        }
    }
}
