//
//  HFPlaceholdImageView.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/15.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

@IBDesignable
class HFPlaceholdImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        layer.cornerRadius = 3
        backgroundColor = HFTheme.BlackAreaColor
    }
    
    
    override func prepareForInterfaceBuilder() {
        setupUI()
    }
}
