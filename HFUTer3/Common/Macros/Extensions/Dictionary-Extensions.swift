//
//  Dictinary-Extensions.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/19.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func update(_ other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
