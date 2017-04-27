//
//  HFScheduleViewCell.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/26.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFScheduleViewCell: HFXibView {
    
    @IBOutlet weak var backView   : UIView!
    @IBOutlet weak var nameLabel  : UILabel!
    @IBOutlet weak var placeLabel : UILabel!
    
    @IBOutlet weak var leadingConstraint  : NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint   : NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint : NSLayoutConstraint!
    @IBOutlet weak var topConstraint      : NSLayoutConstraint!
    
    var models: [HFCourceViewModel] = []
    
    override func initFromXib() {
        super.initFromXib()
        DataEnv.settings.scheduleRoundStyle.asObservable()
            .subscribe(onNext: { [weak self] (element) in
                if element {
                    self?.backView.layer.cornerRadius = 2
                    self?.leadingConstraint.constant  = 2
                    self?.bottomConstraint.constant   = 2
                    self?.trailingConstraint.constant = 2
                    self?.topConstraint.constant      = 2
                } else {
                    self?.backView.layer.cornerRadius = 0
                    self?.leadingConstraint.constant  = 0
                    self?.bottomConstraint.constant   = 0
                    self?.trailingConstraint.constant = 0
                    self?.topConstraint.constant      = 0
                }
                runOnMainThread {
                    self?.layoutIfNeeded()
                }
            }).addDisposableTo(disposeBag)
    }
    
    @IBAction func onCellPressed(_ sender: Any) {
        let vc = HFScheduleInfoViewController()
        vc.models = models
        vc.hidesBottomBarWhenPushed = true
        findViewController()?.pushVC(vc)
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
