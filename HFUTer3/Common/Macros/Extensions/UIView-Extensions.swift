//
//  UIView-Extensions.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/1/31.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit


extension UIView {
    func findViewController() -> UIViewController? {
        var next = self.next
        while next != nil {
            if let next = next as? UIViewController {
                return next
            } else {
                next = next?.next
            }
        }
        return nil
    }
    
    @discardableResult
    func addSeperator(left: CGFloat = 0, right: CGFloat = 0, isTop: Bool = false) -> UIView {
        let seperator = UIView()
        seperator.backgroundColor = HFTheme.SeperatorColor
        self.addSubview(seperator)
        seperator.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(left)
            $0.right.equalTo(self.snp.right).offset(right)
            if isTop {
                $0.top.equalTo(self.snp.top)
            } else {
                $0.bottom.equalTo(self.snp.bottom)
            }
            $0.height.equalTo(0.5)
        }
        return seperator
    }
}
