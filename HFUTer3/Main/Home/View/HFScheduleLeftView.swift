//
//  HFScheduleLeftView.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/26.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFScheduleLeftView: HFView {

    var titleLabel = UILabel()
    
    override func initSetup() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = HFTheme.LightTextColor
    }

}
