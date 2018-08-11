//
//  HFScheduleShareBottonView.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/28.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFScheduleShareBottonView: HFXibView {

    override func initFromXib() {
        super.initFromXib()
        self.backgroundColor = HFTheme.TintColor
        NotificationCenter.default.addObserver(self, selector: #selector(onTintChange), name: .tintColorUpdated, object: nil)
    }
    
    
    @objc func onTintChange() {
        self.backgroundColor = HFTheme.TintColor
    }
}
