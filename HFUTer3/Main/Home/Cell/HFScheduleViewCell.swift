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
                    self?.leadingConstraint.constant  = 0.5
                    self?.bottomConstraint.constant   = 0.5
                    self?.trailingConstraint.constant = 0.5
                    self?.topConstraint.constant      = 0.5
                }
                runOnMainThread {
                    self?.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)
        
        DataEnv.settings.scheduleCellAlpha.asObservable().subscribe(onNext: { [weak self] (element) in
            if let colorName = self?.models.first?.cources.first?.colorName {
                self?.backView.backgroundColor = HFTheme.getColor(with: colorName).withAlphaComponent(element)
            }
        }).disposed(by: disposeBag)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCellPressed(_:)))
        addGestureRecognizer(tap)
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
        if let colorName = models.first?.cources.first?.colorName {
            backView.backgroundColor = HFTheme.getColor(with: colorName).withAlphaComponent(DataEnv.settings.scheduleCellAlpha.value)
        }

        if models.count == 1 {
            nameLabel.text = models.map { $0.name }.joined(separator: " / ")
            placeLabel.text = models.map { $0.place }.joined(separator: " / ")
        } else {
            nameLabel.text = models.map { $0.name.maxLenth(6) }.joined(separator: " / ")
            placeLabel.text = models.map { $0.place }.joined(separator: " / ")
        }
    }
}


extension String {
    func maxLenth(_ len: Int) -> String {
        if self.count <= len {
            return self
        } else {
            return self[0...len]
        }
    }
}
