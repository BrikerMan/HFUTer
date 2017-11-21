//
//  UIDevice-Extensions.swift
//  HFUTer3
//
//  Created by 黄帅 on 2017/11/18.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation

// 因为 iPhone X 只有一种分辨率，那就是 812pt x 375pt (@3x），
// 且没有任何其他设备用了一样的分辨率，特别是高度。

extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}

// UI Data
let NavbarHeight:CGFloat = UIDevice.current.isX() ? (44+44):(20+44)
let NavbarVerticalOffSet:CGFloat = UIDevice.current.isX() ? 22.0:10.0
let TabbarHeight:CGFloat = UIDevice.current.isX() ? 34+49:49

